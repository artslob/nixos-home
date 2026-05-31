{
  description = "NixOS flake for my computers/laptops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-code.url = "github:sadjow/claude-code-nix";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }@inputs:
    let
      hostConfig = {
        asus = { stateVersion = "22.11"; };
        loq = { stateVersion = "24.11"; };
      };
      overlay-claude-code = inputs.claude-code.overlays.default;
      overlay-agenix = final: prev: {
        agenix-cli =
          agenix.packages.${final.stdenv.hostPlatform.system}.default;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.asus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostConfig = hostConfig.asus;
          inherit pkgs-unstable;
        };
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./hosts/asus
          agenix.nixosModules.default
          ({ ... }: {
            nixpkgs.overlays = [ overlay-claude-code overlay-agenix ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              hostConfig = hostConfig.asus;
              inherit pkgs-unstable;
            };
            home-manager.users.artslob = import ./home/asus.nix;
          }
        ];
      };
      nixosConfigurations.loq = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostConfig = hostConfig.loq;
          inherit pkgs-unstable;
        };
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./hosts/loq
          agenix.nixosModules.default
          ({ ... }: {
            nixpkgs.overlays = [ overlay-claude-code overlay-agenix ];
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              hostConfig = hostConfig.loq;
              inherit pkgs-unstable;
            };
            home-manager.users.artslob = import ./home/loq.nix;
          }
        ];
      };
    };
}
