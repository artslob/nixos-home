{ lib, ... }: {
  imports = [ ./common ];
  services.polybar.settings."module/battery".battery = lib.mkForce "BAT1";
}
