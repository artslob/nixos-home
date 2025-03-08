{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../common ];

  networking.hostName = "artslob-laptop";
}
