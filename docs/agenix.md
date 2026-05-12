# Secrets management (agenix)

Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) using SSH keys.
Key mapping is defined in `secrets.nix`.

## Commands

Create or edit a secret:
```bash
agenix -e secrets/secret-name.age
```

Re-key all secrets after adding or removing keys in `secrets.nix`:
```bash
agenix -r
```

Get a host's SSH public key (needed for `secrets.nix`):
```bash
cat /etc/ssh/ssh_host_ed25519_key.pub
```

## Adding a new secret

1. Add the secret entry to `secrets.nix`:
   ```nix
   "secrets/my-secret.age".publicKeys = allKeys;
   ```

2. Create the encrypted file:
   ```bash
   agenix -e secrets/my-secret.age
   ```
   This opens `$EDITOR` where you type the secret content, then saves it encrypted.

3. Declare the secret in your NixOS config (e.g. `hosts/common/default.nix`):
   ```nix
   age.secrets.my-secret.file = ../../secrets/my-secret.age;
   ```

4. Reference the decrypted path where needed:
   ```nix
   some-option = config.age.secrets.my-secret.path;
   ```
   At runtime, agenix decrypts the secret to `/run/agenix/my-secret`.

5. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake .#loq --verbose
   ```
