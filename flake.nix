{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO remove dotfiles
    dotfiles = {
      url = "github:artslob/dotfiles/dev";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, dotfiles, ... }@inputs:
    let
      hostConfig = {
        asus = { stateVersion = "22.11"; };
        loq = { stateVersion = "24.11"; };
      };
    in {
      nixosConfigurations.asus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { hostConfig = hostConfig.asus; };
        modules = [
          ./hosts/asus
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              hostConfig = hostConfig.asus;
              inherit dotfiles;
            };
            home-manager.users.artslob = import ./home/asus.nix;
          }
        ];
      };
      nixosConfigurations.loq = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { hostConfig = hostConfig.loq; };
        modules = [
          ./hosts/loq
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              hostConfig = hostConfig.loq;
              inherit dotfiles;
            };
            home-manager.users.artslob = import ./home/loq.nix;
          }
        ];
      };
    };
}
