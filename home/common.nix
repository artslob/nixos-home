{ pkgs, hostConfig, dotfiles, ... }: {
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

  home.packages = with pkgs;
    [
      # useful to check names of gtk icons/themes
      lxappearance
    ];

  programs.starship.enable = true;

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
    config = null;
    extraConfig = builtins.readFile "${dotfiles}/i3/.config/i3/config";
  };

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
