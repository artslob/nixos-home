# GNOME keyring password out of sync after password change

## Problem

The password is changed declaratively by swapping the agenix hash in
`secrets/artslob-password-hash.age` (fed to `hashedPasswordFile`). This updates
the **account** password, so login and `sudo` work with the new password.

The GNOME **login** keyring (`~/.local/share/keyrings/login.keyring`) is a
separate AES-encrypted file, encrypted with the password that was in effect when
it was created. A declarative password change does not re-encrypt it, so the
keyring prompt (Bitwarden, `nm-applet`, etc.) still only opens with the **old**
password.

Normally `pam_gnome_keyring.so` in the *password* PAM stack re-encrypts the
keyring when the password is changed with an interactive `passwd`. Editing the
hash file bypasses that hook, so the account password and keyring password drift
apart. This recurs on every declarative password change.

## Solution A — re-key the keyring (keeps stored secrets, recommended)

Seahorse isn't installed by default. Run it from a temporary shell (the old
password still unlocks the keyring, so it can be re-keyed):

```bash
nix-shell -p seahorse --run seahorse
```

In Seahorse: right-click the **Login** keyring → **Change Password** → enter the
**old** password (current keyring password) → set it to the **new** login
password. The keyring now matches the account password.

## Solution B — delete and recreate (loses stored secrets)

Only if re-entering saved secrets is acceptable:

```bash
rm ~/.local/share/keyrings/login.keyring
```

On next login `pam_gnome_keyring` creates a fresh `login` keyring encrypted with
the current (new) password. Anything previously stored (Bitwarden master
password, wifi passwords in `nm-applet`, etc.) must be re-entered.
