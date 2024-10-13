# gcloud-nix

A [make-shell](https://github.com/nicknovitski/make-shell) module for [the Google Cloud SDK](https://cloud.google.com/sdk), or `gcloud`.

## Why?

`make-shell` is a modular interface for making nix derivations intended for use by the `nix develop` command.  It has it's own lengthy [WHY document](https://github.com/nicknovitski/make-shell/blob/main/WHY.md).

I wrote this module to scratch a small itch I had when working on a bunch of projects were all deployed to Google Cloud, especially on Google Kubernetes Engine.  Once this module existed I could write a module that defines shared settings, and have project-specific overrides this:
```
# gke.nix
{pkgs, ...}: {
  gcloud.enable = true;
  gcloud.extra-components = [ "kubectl" "gke-gcloud-auth-plugin" "skaffold" ];
}

# For each project:
pkgs.make-shell {
  imports = [./gke.nix]; # DRY!
  # project-specific options
}

# For example, a project which also uses pubsub:
pkgs.make-shell ({pkgs, ...}: {
  imports = [./gke.nix];
  gcloud.extra-components = [ "pubsub-emulator" ]; # merges cleanly with the components in gke.nix!
  packages = [ pkgs.openjdk ]; # necessary for the emulator to run
})
```

## Installation

First make sure that you've [installed `make-shell` in your flake](https://github.com/nicknovitski/make-shell/tree/main?tab=readme-ov-file#installation).

Then, add `gcloud` to your flake inputs.  Maybe they'd look like this:
```nix
  inputs = {
    gcloud-nix.url = "github:nicknovitski/gcloud-nix";
    make-shell.url = "github:nicknovitski/make-shell";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
```

Then, add the shell module to your shell's imports.  It'll look something like this:
```nix
devShells.default = pkgs.make-shell = { 
  imports = [inputs.gcloud-nix.shellModules.default]; # add option declarations...
  gcloud.enable = true; # ...and definitions!
}
# or, if you're using flake-parts...
make-shell.imports = [gcloud-nix.shellModules.default]; # shared imports for all `make-shells` attributes
make-shells.default = {gcloud.enable = true;};
```

## Usage

The options which this module declares are documented [the OPTIONS.md file](OPTIONS.md).  Although if you know even a little nix, I bet you can read the declarations directly from [the module itself](shell-modules/default.nix).

## Examples

See [example/flake.nix](example/flake.nix).
