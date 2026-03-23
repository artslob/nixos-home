# home-nixos

To build flake use:
```bash
sudo nixos-rebuild switch --flake .#asus --verbose
# or
sudo nixos-rebuild switch --flake .#loq --verbose
```

To test flake use:
```bash
sudo nixos-rebuild test --flake .#asus --verbose
# or
sudo nixos-rebuild test --flake .#loq --verbose
```
