{ pkgs, lib, hostConfig, dotfiles, config, ... }: {
  imports = [ ./alacritty.nix ./i3.nix ];

  home.stateVersion = hostConfig.stateVersion;

  programs.bash = {
    enable = true;
    shellAliases = {
      p = "pwd";
      g = "git";
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

  # to read logs: journalctl --user -xeu polybar
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      pulseSupport = true;
    };
    settings = let
      # Define the color palette once so you can reuse these values throughout.
      colors = {
        background = "#282A2E";
        "background-alt" = "#373B41";
        foreground = "#FFFFFF";
        primary = "#9ECE6A";
        secondary = "#FACD76";
        alert = "#F50000";
        disabled = "#707880";
      };
    in {
      # [colors] section
      "colors" = {
        background = colors.background;
        "background-alt" = colors."background-alt";
        foreground = colors.foreground;
        primary = colors.primary;
        secondary = colors.secondary;
        alert = colors.alert;
        disabled = colors.disabled;
      };

      # [bar/main] section
      "bar/main" = {
        width = "100%";
        height = "24pt";
        bottom = true;
        background = colors.background;
        foreground = colors.foreground;
        "line-size" = "3pt";
        "padding-left" = 0;
        "padding-right" = 1;
        "module-margin" = 1;
        separator = "|";
        "separator-foreground" = colors.disabled;

        # Fonts are 1-indexed; these correspond to font-N in your original config.
        "font-0" = "JetBrains Mono:style=Regular:size=10.5;2";
        "font-1" =
          "Font Awesome 6 Free,Font Awesome 6 Free Regular:style=Regular:size=10.5;2";
        "font-2" =
          "Font Awesome 6 Brands,Font Awesome 6 Brands Regular:style=Regular:size=10.5;2";
        "font-3" =
          "Font Awesome 6 Free,Font Awesome 6 Free Solid:style=Solid:size=10.5;2";

        "modules-left" = "i3 xwindow";
        "modules-right" =
          "xkeyboard pulseaudio filesystem memory cpu battery wlan eth date";
        "cursor-click" = "pointer";
        "cursor-scroll" = "ns-resize";
        "enable-ipc" = true;
        "tray-position" = "right";
      };

      # [module/i3] section
      "module/i3" = {
        type = "internal/i3";
        "pin-workspaces" = true;
        "enable-scroll" = false;
        # ws-icon-[0-9]+ = <label>;<icon>
        # NOTE: The <label> needs to match the name of the i3 workspace
        # Neither <label> nor <icon> can contain a semicolon (;)
        "ws-icon-0" = "1;  ";
        "ws-icon-1" = "2;  ";
        "ws-icon-2" = "3;  ";
        "ws-icon-3" = "4;4 ";
        "ws-icon-4" = "5;  ";
        "ws-icon-5" = "6;6 ";
        "ws-icon-6" = "7;7 ";
        "ws-icon-7" = "8;  ";
        "ws-icon-8" = "9;  ";
        "ws-icon-9" = "10;10 ";
        format = "<label-state> <label-mode>";
        "label-mode" = "%mode%";
        "label-mode-foreground" = colors.alert;
        "label-mode-underline" = colors.alert;
        "label-mode-padding" = 1;
        "label-focused" = "%icon%";
        "label-focused-background" = colors."background-alt";
        "label-focused-underline" = colors.primary;
        "label-focused-padding" = 1;
        "label-unfocused" = "%icon%";
        "label-unfocused-padding" = 1;
        "label-visible" = "%icon%";
        # The self references here follow the original config.
        "label-visible-background" = "${self.label-focused-background}";
        "label-visible-underline" = "${self.label-focused-underline}";
        "label-visible-padding" = "${self.label-focused-padding}";
        "label-urgent" = "%icon%";
        "label-urgent-foreground" = colors.alert;
        "label-urgent-underline" = colors.alert;
        "label-urgent-padding" = 1;
        "label-separator" = "|";
      };

      # [module/xwindow]
      "module/xwindow" = {
        type = "internal/xwindow";
        "label-maxlen" = 80;
      };

      # [module/filesystem]
      "module/filesystem" = {
        type = "internal/fs";
        interval = 60;
        "mount-0" = "/";
        "format-mounted-prefix" = " ";
        "format-mounted-prefix-foreground" = colors.primary;
        "label-mounted" = "%percentage_used%%";
        "label-unmounted" = "%mountpoint% not mounted";
        "label-unmounted-foreground" = colors.disabled;
        "warn-percentage" = 80;
        "format-warn" = "<label-warn>";
        "format-warn-prefix" = "${self.format-mounted-prefix}";
        "format-warn-prefix-foreground" = colors.alert;
        "label-warn" = "${self.label-mounted}";
      };

      # [module/pulseaudio]
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        "format-volume" = "<ramp-volume> <label-volume>";
        "ramp-volume-foreground" = colors.secondary;
        "ramp-volume-0" = "";
        "ramp-volume-1" = "";
        "ramp-volume-2" = "";
        "label-volume" = "%percentage:02%%";
        "label-muted" = " %percentage:02%%";
        "label-muted-foreground" = colors.disabled;
        "click-right" = "pavucontrol";
      };

      # [module/xkeyboard]
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        "blacklist-0" = "num lock";
        "blacklist-1" = "scroll lock";
        "format-prefix" = " ";
        "format-prefix-foreground" = colors.secondary;
        "label-layout" = "%icon%";
        "layout-icon-0" = "us;";
        "layout-icon-1" = "ru;%{F#0a6cf5}%{F-}";
        "label-indicator-on" = "%name%";
        "label-indicator-on-padding" = 1;
        "label-indicator-on-margin" = 1;
        "label-indicator-on-foreground" = colors.background;
        "label-indicator-on-background" = colors.secondary;
      };

      # [module/memory]
      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format = "<label>";
        "format-prefix" = " ";
        "format-prefix-foreground" = colors.primary;
        label = "%percentage_used:2%%";
        "warn-percentage" = 90;
        "format-warn" = "<label-warn>";
        "format-warn-prefix" = "${self.format-prefix}";
        "format-warn-prefix-foreground" = colors.alert;
        "label-warn" = "${self.label}";
      };

      # [module/cpu]
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format = "<label>";
        "format-prefix" = " ";
        "format-prefix-foreground" = colors.primary;
        label = "%percentage:02%%";
        "warn-percentage" = 90;
        "format-warn" = "<label-warn>";
        "format-warn-prefix" = "${self.format-prefix}";
        "format-warn-prefix-foreground" = colors.alert;
        "label-warn" = "${self.label}";
      };

      # [module/battery]
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
        "time-format" = "%H:%M";
        "full-at" = 95;
        "low-at" = 30;
        "poll-interval" = 20;
        "format-full-prefix" = " ";
        "format-full-prefix-foreground" = colors.primary;
        "format-full" = "<label-full>";
        "format-charging" = "<animation-charging> <label-charging>";
        "label-charging" = "%percentage%%";
        "animation-charging-0" = "";
        "animation-charging-1" = "";
        "animation-charging-2" = "";
        "animation-charging-3" = "";
        "animation-charging-foreground" = colors.primary;
        "animation-charging-framerate" = 650;
        "format-discharging" = "<animation-discharging> <label-discharging>";
        "label-discharging" = "%percentage%% %time%";
        "animation-discharging-0" = "";
        "animation-discharging-1" = "";
        "animation-discharging-2" = "";
        "animation-discharging-3" = "";
        "animation-discharging-foreground" = colors.primary;
        "animation-discharging-framerate" =
          "${self.animation-charging-framerate}";
        "format-low" = "<animation-low> <label-low>";
        "animation-low-0" = "${self.animation-discharging-0}";
        "animation-low-1" = "${self.animation-discharging-1}";
        "animation-low-2" = "${self.animation-discharging-2}";
        "animation-low-3" = "${self.animation-discharging-3}";
        "animation-low-foreground" = colors.alert;
        "animation-low-framerate" = "${self.animation-charging-framerate}";
      };

      # [network-base] used by the WLAN and Ethernet modules
      "network-base" = {
        type = "internal/network";
        interval = 5;
        "format-connected" = "<label-connected>";
        "format-disconnected" = "";
      };

      # [module/wlan]
      "module/wlan" = {
        "inherit" = "network-base";
        "interface-type" = "wireless";
        "format-connected-prefix" = " ";
        "format-connected-prefix-foreground" = colors.primary;
        "label-connected" = "%signal%";
      };

      # [module/eth]
      "module/eth" = {
        "inherit" = "network-base";
        "interface-type" = "wired";
        "format-connected-foreground" = colors.primary;
        "label-connected" = "";
      };

      # [module/date]
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%d %b, %A";
        "date-alt" = "%d-%m-%Y";
        time = "%H:%M";
        "time-alt" = "%H:%M";
        label = "%date% %time%";
      };

      # [settings] section
      "settings" = {
        "screenchange-reload" = true;
        "pseudo-transparency" = true;
      };
    };
    # script = ''
    #   polybar -c "${dotfiles}/polybar/.config/polybar/config.ini" 2>&1 &
    # '';
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

  programs.git = {
    enable = true;
    userName = "artslob";
    userEmail = "artslob@yandex.ru";
    extraConfig = {
      core.editor = "vim";
      core.quotePath = false;
      init.defaultBranch = "main";
    };
    aliases = {
      a = "add";
      au = "add -u";
      s = "status";
      c = "commit";
      ca = "commit -a";
      d = "diff";
      dc = "diff --cached";
      pu = "push";
      ch = "checkout";
      l = "log";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    };
  };
}
