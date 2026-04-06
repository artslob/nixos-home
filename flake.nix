{
  description = "NixOS flake for my computers/laptops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    claude-code.url = "github:sadjow/claude-code-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, claude-code, home-manager, ... }@inputs:
    let
      hostConfig = {
        asus = { stateVersion = "22.11"; };
        loq = { stateVersion = "24.11"; };
      };
      overlay-claude-code = claude-code.overlays.default;
    in {
      nixosConfigurations.asus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { hostConfig = hostConfig.asus; };
        modules = [
          ./hosts/asus
          ({ ... }: { nixpkgs.overlays = [ overlay-claude-code ]; })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { hostConfig = hostConfig.asus; };
            home-manager.users.artslob = import ./home/asus.nix;
          }
        ];
      };
      nixosConfigurations.loq = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { hostConfig = hostConfig.loq; };
        modules = [
          ./hosts/loq
          ({ ... }: { nixpkgs.overlays = [ overlay-claude-code ]; })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { hostConfig = hostConfig.loq; };
            home-manager.users.artslob = import ./home/loq.nix;
          }
        ];
      };
    };
}
