# This file maps encrypted secret files to the public keys that can decrypt them.
# Used by the `agenix` CLI only (not imported into NixOS configuration).
#
# Usage:
#   agenix -e secrets/secret-name.age       # create/edit a secret
#   agenix -r                               # re-key all secrets after adding/removing keys
#
# To get SSH host public keys from a machine:
#   cat /etc/ssh/ssh_host_ed25519_key.pub
#
# To get your user SSH public key:
#   cat ~/.ssh/id_ed25519.pub

let
  user-artslob = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBiAvme/Pup3RUJRZIrQAfUqVH0XGAmr173XHtYeF669";

  host-loq = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFE3MyuBdsNvTJuo4MGGKi8OF7liy85o22oBBeGEZkED";

  allKeys = [
    user-artslob
    host-loq
  ];
in
{
  "secrets/wireguard-private-key.age".publicKeys = allKeys;
  "secrets/artslob-password-hash.age".publicKeys = allKeys;
}
