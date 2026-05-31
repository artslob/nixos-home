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
      # Unfree packages permitted on all hosts, shared by stable and unstable.
      allowUnfreePredicate =
        pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "zoom"
          "slack"
          "claude-code"
          "cursor-cli"
        ];

      overlay-claude-code = inputs.claude-code.overlays.default;
      overlay-agenix = final: prev: {
        agenix-cli = agenix.packages.${final.stdenv.hostPlatform.system}.default;
      };
      # Expose nixpkgs-unstable as `pkgs.unstable.<name>`.
      overlay-unstable = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          config.allowUnfreePredicate = allowUnfreePredicate;
        };
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
        nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.hostPlatform = system;
              nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;
              system.stateVersion = stateVersion;
              home-manager.users.artslob.home.stateVersion = stateVersion;
            }
            ./hosts/${name}
            agenix.nixosModules.default
            {
              nixpkgs.overlays = [
                overlay-claude-code
                overlay-agenix
                overlay-unstable
              ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
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
