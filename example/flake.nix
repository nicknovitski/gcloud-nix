{
  description = "An example usage of the gcloud-nix shell modules, with flake-parts";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    gcloud-nix.url = "github:nicknovitski/gcloud-nix";
    make-shell.url = "github:nicknovitski/make-shell";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    inputs@{
      flake-parts,
      make-shell,
      gcloud-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      imports = [ make-shell.flakeModules.default ];
      perSystem =
        { ... }:
        {
          make-shell.imports = [ gcloud-nix.shellModules.default ];
          make-shells.default =
            { pkgs, ... }:
            {
              gcloud = {
                enable = true;
                extra-components = [
                  "gke-gcloud-auth-plugin"
                  "kubectl"
                ];
                properties.core.project = "my-gcp-project";
              };
            };
        };
    };
}
