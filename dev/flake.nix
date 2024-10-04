{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    make-shell.url = "github:nicknovitski/make-shell";
  };

  outputs =
    inputs@{ flake-parts, make-shell, ... }:
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
          make-shells.default =
            { pkgs, ... }:
            {
              packages = [ pkgs.nixfmt-rfc-style ];
            };
        };
    };
}
