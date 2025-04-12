{ ... }: {
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
            args = [ "-c" ./clear-focused-tty.sh ];
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
}
