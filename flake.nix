{
  description = "home flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }: 
  flake-utils.lib.eachDefaultSystem (system:
    let
      ubreu = home-manager.lib.homeManagerConfiguration {  
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
      };
    in {
      packages.default = ubreu.activationPackage;
    });
}