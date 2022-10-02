{
  description = "home flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
  };

  outputs = { self, nixpkgs, home-manager }: 
  let 
    system = "x86_64-darwin"; 

    ubreu = home-manager.lib.homeManagerConfiguration {  
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
    };
  in {
    defaultPackage.${system} = ubreu.activationPackage;
  };
}