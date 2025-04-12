{ pkgs, lib, config, ... }: {
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
          "${modifier}+0" = "workspace 10";
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";
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
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
          "XF86MonBrightnessDown" =
            "exec --no-startup-id brightnessctl set 5%-";
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
}
