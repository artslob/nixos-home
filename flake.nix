{
  description = "A simple NixOS flake";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.artslob-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
      ];
    };
  };
}
