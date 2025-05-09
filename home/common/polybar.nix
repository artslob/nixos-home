{ pkgs, lib, ... }: {
  # to read logs: journalctl --user -xeu polybar
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      pulseSupport = true;
    };
    settings = let
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
      "colors" = {
        background = colors.background;
        "background-alt" = colors."background-alt";
        foreground = colors.foreground;
        primary = colors.primary;
        secondary = colors.secondary;
        alert = colors.alert;
        disabled = colors.disabled;
      };
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
          "xkeyboard pulseaudio backlight filesystem memory cpu battery wlan eth date";
        "cursor-click" = "pointer";
        "cursor-scroll" = "ns-resize";
        "enable-ipc" = true;
        "tray-position" = "right";
      };
      "module/i3" = rec {
        type = "internal/i3";
        "pin-workspaces" = true;
        "enable-scroll" = false;
        # ws-icon-[0-9]+ = <label>;<icon>
        # NOTE: The <label> needs to match the name of the i3 workspace
        # Neither <label> nor <icon> can contain a semicolon (;)
        "ws-icon-0" = "1;  ";
        "ws-icon-1" = "2;  ";
        "ws-icon-2" = "3;  ";
        "ws-icon-3" = "4;  ";
        "ws-icon-4" = "5;  ";
        "ws-icon-5" = "6;  ";
        "ws-icon-6" = "7;  ";
        "ws-icon-7" = "8;  ";
        "ws-icon-8" = "9;  ";
        "ws-icon-9" = "10;  ";
        format = "<label-state> <label-mode>";
        # shows modes, for example "resize"
        "label-mode" = "%mode%";
        "label-mode-foreground" = colors.alert;
        "label-mode-underline" = colors.alert;
        "label-mode-padding" = 1;
        # focused = Active workspace on focused monitor
        "label-focused" = "%icon%";
        "label-focused-background" = colors."background-alt";
        "label-focused-underline" = colors.primary;
        "label-focused-padding" = 1;
        # unfocused = Inactive workspace on any monitor
        "label-unfocused" = "%icon%";
        "label-unfocused-padding" = 1;
        # visible = Active workspace on unfocused monitor
        "label-visible" = "%icon%";
        "label-visible-background" = label-focused-background;
        "label-visible-underline" = label-focused-underline;
        "label-visible-padding" = label-focused-padding;
        # urgent = Workspace with urgency hint set
        "label-urgent" = "%icon%";
        "label-urgent-foreground" = colors.alert;
        "label-urgent-underline" = colors.alert;
        "label-urgent-padding" = 1;
        # Separator in between workspaces
        "label-separator" = "|";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        "label-maxlen" = 80;
      };
      "module/filesystem" = rec {
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
        "format-warn-prefix" = format-mounted-prefix;
        "format-warn-prefix-foreground" = colors.alert;
        "label-warn" = label-mounted;
      };
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
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        "blacklist-0" = "num lock";
        "blacklist-1" = "scroll lock";
        "format-prefix" = " ";
        "format-prefix-foreground" = colors.secondary;
        "label-layout" = "%icon%";
        # Assign each layout an icon that will be available as %icon% token for the <label-layout> tag.
        # The part before ';' will try to match %layout% value.
        "layout-icon-0" = "us;";
        "layout-icon-1" = "ru;%{F#0a6cf5}%{F-}";
        "label-indicator-on" = "%name%";
        "label-indicator-on-padding" = 1;
        "label-indicator-on-margin" = 1;
        "label-indicator-on-foreground" = colors.background;
        "label-indicator-on-background" = colors.secondary;
      };
      "module/memory" = rec {
        type = "internal/memory";
        interval = 2;
        format = "<label>";
        "format-prefix" = " ";
        "format-prefix-foreground" = colors.primary;
        label = "%percentage_used:2%%";
        "warn-percentage" = 90;
        "format-warn" = "<label-warn>";
        "format-warn-prefix" = format-prefix;
        "format-warn-prefix-foreground" = colors.alert;
        "label-warn" = label;
      };
      "module/cpu" = rec {
        type = "internal/cpu";
        interval = 2;
        format = "<label>";
        "format-prefix" = " ";
        "format-prefix-foreground" = colors.primary;
        label = "%percentage:02%%";
        "warn-percentage" = 90;
        "format-warn" = "<label-warn>";
        "format-warn-prefix" = format-prefix;
        "format-warn-prefix-foreground" = colors.alert;
        "label-warn" = label;
      };
      "module/battery" = rec {
        type = "internal/battery";
        # Use the following command to list batteries and adapters:
        # ls -1 /sys/class/power_supply/
        battery = lib.mkDefault "BAT0";
        adapter = lib.mkDefault "AC";
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
        "animation-discharging-framerate" = animation-charging-framerate;
        "format-low" = "<animation-low> <label-low>";
        "animation-low-0" = animation-discharging-0;
        "animation-low-1" = animation-discharging-1;
        "animation-low-2" = animation-discharging-2;
        "animation-low-3" = animation-discharging-3;
        "animation-low-foreground" = colors.alert;
        "animation-low-framerate" = animation-charging-framerate;
      };
      "network-base" = {
        type = "internal/network";
        interval = 5;
        "format-connected" = "<label-connected>";
        "format-disconnected" = "";
      };
      "module/wlan" = {
        "inherit" = "network-base";
        "interface-type" = "wireless";
        "format-connected-prefix" = " ";
        "format-connected-prefix-foreground" = colors.primary;
        "label-connected" = "%signal%";
      };
      "module/eth" = {
        "inherit" = "network-base";
        "interface-type" = "wired";
        "format-connected-foreground" = colors.primary;
        "label-connected" = "";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%d %b, %A";
        "date-alt" = "%d-%m-%Y";
        time = "%H:%M";
        "time-alt" = "%H:%M";
        label = "%date% %time%";
      };
      "module/backlight" = {
        type = "internal/backlight";
        "enable-scroll" = false;
        "scroll-interval" = 5;
        "format-prefix" = " ";
        "format-prefix-foreground" = colors.primary;
      };
      "settings" = {
        "screenchange-reload" = true;
        "pseudo-transparency" = true;
      };
    };
    script = "polybar main &";
  };
}
