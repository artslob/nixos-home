{
  description = "NixOS flake for my computers/laptops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-code.url = "github:sadjow/claude-code-nix";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      agenix,
      ...
    }@inputs:
    let
      overlay-claude-code = inputs.claude-code.overlays.default;
      overlay-agenix = final: prev: {
        agenix-cli = agenix.packages.${final.stdenv.hostPlatform.system}.default;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      # Build a NixOS system for one host. Shared scaffolding lives here;
      # per-host config belongs in ./hosts/<name> and ./home/<name>.nix.
      #
      #   name         - host dir under ./hosts and home file ./home/<name>.nix
      #   stateVersion - NixOS/home-manager state version for this host
      #   system       - platform double (default x86_64-linux)
      #   extraModules - host-specific NixOS modules, e.g. modules pulled from
      #                  other flake inputs that only one host should get
      mkHost =
        {
          name,
          stateVersion,
          system ? "x86_64-linux",
          extraModules ? [ ],
        }:
        let
          hostConfig = { inherit stateVersion; };
          specialArgs = { inherit hostConfig pkgs-unstable; };
        in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            { nixpkgs.hostPlatform = system; }
            ./hosts/${name}
            agenix.nixosModules.default
            {
              nixpkgs.overlays = [
                overlay-claude-code
                overlay-agenix
              ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.artslob = import ./home/${name}.nix;
            }
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        asus = mkHost {
          name = "asus";
          stateVersion = "22.11";
        };
        loq = mkHost {
          name = "loq";
          stateVersion = "24.11";
        };
      };
    };
}
