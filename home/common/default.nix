{ pkgs, lib, hostConfig, config, ... }: {
  imports = [ ./alacritty.nix ./git.nix ./i3.nix ./polybar.nix ];

  home.stateVersion = hostConfig.stateVersion;

  programs.bash = {
    enable = true;
    shellAliases = {
      p = "pwd";
      g = "git";
      l = "ls -l";
      ll = "ls -alh";
    };
    bashrcExtra = ''
      # fix for nix-shell and starship
      export STARSHIP_PREEXEC_READY=true;

      [ -r ~/.bashrc-extra ] && . ~/.bashrc-extra
    '';
  };

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
  };

  xsession.enable = true;

  home.packages = with pkgs; [
    # useful to check names of gtk icons/themes
    lxappearance
    # for amixer
    alsa-utils
  ];

  programs.starship = {
    enable = true;
    settings = {
      cmd_duration = {
        show_notifications = true;
        min_time_to_notify = 5000;
        notification_timeout = 5000;
      };
    };
  };

  services.dunst.enable = true;

  services.blueman-applet.enable = true;

  # to list all .desktop entries:
  # for p in ${XDG_DATA_DIRS//:/ }; do find $p/applications -name '*.desktop' ; done
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "codium.desktop" ];
      "text/markdown" = [ "codium.desktop" ];
      "image/png" = [ "org.nomacs.ImageLounge.desktop" ];
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "x-scheme-handler/bitwarden" = [ "bitwarden.desktop" ];
      "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    publicShare = null;
    templates = null;
  };
}
