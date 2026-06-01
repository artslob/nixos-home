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
}
