{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let hostConfig = { asus = { stateVersion = "22.11"; }; };
    in {
      nixosConfigurations.artslob-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { hostConfig = hostConfig.asus; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.artslob = import ./home.nix;
          }
        ];
      };
    };
}
