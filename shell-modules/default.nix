{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    filterAttrs
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.attrsets) attrNames mapAttrs' concatMapAttrs;
  cfg = config.gcloud;
in
{
  options.gcloud = {
    enable = mkEnableOption "Install the Google Cloud SDK";
    extra-components = mkOption {
      description = "IDs of Google Cloud SDK components to install";
      default = [ ];
      example = [ "gke-gcloud-auth-plugin" ];
      type = types.listOf (types.enum (attrNames pkgs.google-cloud-sdk.components));
    };
    package = mkOption {
      readOnly = true;
      internal = true;
      type = types.package;
      default =
        if cfg.extra-components == [ ] then
          pkgs.google-cloud-sdk
        else
          pkgs.google-cloud-sdk.withExtraComponents (
            builtins.map (c: pkgs.google-cloud-sdk.components.${c}) cfg.extra-components
          );
    };
    config-directory = mkOption {
      default = null;
      description = "Path to the config directory";
      type = types.nullOr types.nonEmptyStr;
    };
    active-configuration-name = mkOption {
      default = null;
      description = "The name of the configuration to use in the shell";
      type = types.nullOr types.nonEmptyStr;
    };
    properties = mkOption {
      default = { };
      description = "Configuration properties to set in the shell";
      type = types.attrsOf (
        types.attrsOf (
          types.oneOf [
            types.nonEmptyStr
            types.bool
          ]
        )
      );
    };
    configEnvVars = mkOption {
      readOnly = true;
      internal = true;
      type = types.attrsOf types.nonEmptyStr;
      default =
        let
          toEnvName = s: builtins.replaceStrings [ "-" ] [ "_" ] (lib.strings.toUpper s);
          sectionsToEnv =
            section:
            mapAttrs' (
              property: value: {
                inherit value;
                name = "CLOUDSDK_${toEnvName section}_${toEnvName property}";
              }
            );
        in
        concatMapAttrs sectionsToEnv cfg.properties;
    };
  };
  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];
    env =
      (filterAttrs (_: v: v != null) {
        CLOUDSDK_CONFIG = cfg.config-directory;
        CLOUDSDK_ACTIVE_CONFIG_NAME = cfg.active-configuration-name;
      })
      // cfg.configEnvVars;
  };
}
