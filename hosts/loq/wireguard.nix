{ config, ... }:
{
  age.secrets.wireguard-private-key.file = ../../secrets/wireguard-private-key.age;

  networking.wg-quick.interfaces.wg0 = {
    address = [
      "10.0.0.2/24"
      "fdc9:281f:04d7:9ee9::2/64"
    ];
    privateKeyFile = config.age.secrets.wireguard-private-key.path;

    peers = [
      {
        publicKey = "badrGTyvIsmQUK1k2rjSUxfInUdJXjWzsq0qm86Df3E=";
        endpoint = "artslob.me:51820";
        allowedIPs = [
          "10.0.0.0/24"
          "fdc9:281f:04d7:9ee9::/64"
        ];
        persistentKeepalive = 25;
      }
    ];
  };

  # Expose SSH (configured in ../common) only over the WireGuard interface.
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ 22 ];

  users.users.artslob.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWGIVgIJ4oTrlQo3C8KfSrX0JmUP31byr8cIYozmX5A"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMKfn6l7/F8vGBD5BbAzs6CLkpz/9kJA8NAfmbrlnG6E"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALE7m9huHgRQJpAirBTmDYVM/FhTR0gUpW95M11t3Qh"
  ];
}
