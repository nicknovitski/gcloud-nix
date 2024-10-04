# gcloud-nix

A [make-shell](https://github.com/nicknovitski/make-shell) module for the Google Cloud SDK, or `gcloud` CLI tool.

## Why?

`make-shell` is a modular interface for making nix derivations intended for use by the `nix develop` command.  It has it's own lengthy [WHY document](https://github.com/nicknovitski/make-shell/blob/main/WHY.md).

The Google Cloud SDK nix package has a

 
This is a module for `make-shell` that lets you 

I work on projects  which attempts to explain how it might be useful, but I thought that creating this repository might also give an indirect explanation.  

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
  javascript.gcloud.enable = true; # ...and definitions!
}
# or, if you're using flake-parts...
make-shell.imports = [gcloud-nix.shellModules.default]; # shared imports for all `make-shells` attributes
make-shells.default = {gcloud.enable = true;};
```

## Usage

The options this module declares are documented [the OPTIONS.md file](OPTIONS.md).  Although if you know even a little nix, I bet you can read the declarations directly from [the module itself](shell-modules/default.nix) directory.

## Examples

See [example/flake.nix](example/flake.nix).
