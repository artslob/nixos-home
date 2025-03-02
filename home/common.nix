{ pkgs, lib, hostConfig, dotfiles, config, ... }: {
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

  programs.alacritty = {
    enable = true;
    settings = {
      scrolling.history = 30000;
      keyboard.bindings = [
        {
          key = "K";
          mods = "Control|Shift";
          mode = "~Alt";
          command = {
            program = "bash";
            args = [
              "-c"
              "${dotfiles}/alacritty/.config/alacritty/clear-focused-tty.sh"
            ];
          };
        }
        {
          key = "K";
          mods = "Control|Shift";
          mode = "~Alt";
          chars = "\r";
        }
      ];
      colors = {
        draw_bold_text_with_bright_colors = true;

        bright = {
          black = "#7f8c8d";
          blue = "#3daee9";
          cyan = "#16a085";
          green = "#1cdc9a";
          magenta = "#8e44ad";
          red = "#c0392b";
          white = "#ffffff";
          yellow = "#fdbc4b";
        };

        dim = {
          black = "#31363b";
          blue = "#1b668f";
          cyan = "#186c60";
          green = "#17a262";
          magenta = "#614a73";
          red = "#783228";
          white = "#63686d";
          yellow = "#b65619";
        };

        normal = {
          black = "#232627";
          blue = "#1d99f3";
          cyan = "#1abc9c";
          green = "#11d116";
          magenta = "#9b59b6";
          red = "#ed1515";
          white = "#fcfcfc";
          yellow = "#f67400";
        };

        primary = {
          background = "#232627";
          bright_foreground = "#ffffff";
          dim_foreground = "#eff0f1";
          foreground = "#fcfcfc";
        };

        search = {
          focused_match = {
            background = "#d00000";
            foreground = "#ffffff";
          };
          matches = {
            background = "#9ece6a";
            foreground = "#000000";
          };
        };
      };
      font = {
        size = 13;
        bold.family = "JetBrainsMono Nerd Font Mono";
        bold_italic.family = "JetBrainsMono Nerd Font Mono";
        italic.family = "JetBrainsMono Nerd Font Mono";
        normal.family = "JetBrainsMono Nerd Font Mono";
      };
    };
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      fonts = {
        names = [ "JetBrains Mono" ];
        size = 9.0;
      };
      colors.focused = {
        border = "#9ECE6A";
        background = "#373B41";
        text = "#FFFFFF";
        indicator = "#FFFFFF";
        childBorder = "#9ECE6A";
      };
      gaps = {
        inner = 12;
        smartGaps = true;
      };
      bars = [ ];
      keybindings =
        let modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec rofi -show run";
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";
          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          # TODO focus child?
          "${modifier}+a" = "focus parent";
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 0";
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 0";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" = ''
            exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"'';
          "${modifier}+Tab" = "workspace back_and_forth";
          "${modifier}+Next" = "workspace next_on_output";
          "${modifier}+Prior" = "workspace prev_on_output";
          "${modifier}+l" = "exec i3lock -fe";
          "${modifier}+bracketleft" =
            ''exec --no-startup-id "dunstctl history-pop"'';
          "${modifier}+bracketright" =
            ''exec --no-startup-id "dunstctl close"'';
          "${modifier}+r" = "mode resize";
          "XF86AudioMute" =
            ''exec --no-startup-id "amixer sset Master toggle"'';
          "${modifier}+F10" =
            ''exec --no-startup-id "amixer sset Master toggle"'';
          "XF86AudioLowerVolume" =
            ''exec --no-startup-id "amixer sset Master 5%-"'';
          "${modifier}+F11" = ''exec --no-startup-id "amixer sset Master 5%-"'';
          "XF86AudioRaiseVolume" =
            ''exec --no-startup-id "amixer sset Master 5%+"'';
          "${modifier}+F12" = ''exec --no-startup-id "amixer sset Master 5%+"'';
        };
      modes = {
        resize = {
          Left = "resize shrink width 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Escape = "mode default";
          Return = "mode default";
        };
      };
      startup = [
        {
          command = "systemctl --user restart polybar";
          always = true;
          notification = false;
        }
        {
          command = "shutter --min_at_startup";
          always = false;
          notification = false;
        }
      ];
    };
    extraConfig = ''
      default_border pixel 3
      default_floating_border pixel 3
      hide_edge_borders smart
    '';
  };

  # to read logs: journalctl --user -xeu polybar
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      pulseSupport = true;
    };
    script = ''
      polybar -c "${dotfiles}/polybar/.config/polybar/config.ini" 2>&1 &
    '';
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
