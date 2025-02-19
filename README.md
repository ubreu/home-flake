# Flake for Nix Home Manager

This project contains the flake for installing home manager and the configuration it manages for my home directory.
See https://nixos.wiki/wiki/Home_Manager

Activate the configuration by either running:
```console
nix run github:ubreu/home-flake
```

or:
```console
git@github.com:ubreu/home-flake.git
cd home-flake
nix run . switch
```

## Updating nixpkgs and home-manager

```console
nix flake update
nix run . switch
```