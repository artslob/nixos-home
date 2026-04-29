{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    terminal = "tmux-256color";
    historyLimit = 100000;
    shell = "${pkgs.bash}/bin/bash";

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
        '';
      }
    ];

    extraConfig = ''
      # Terminal title (reflects in Alacritty window)
      set -g set-titles on
      set -g set-titles-string "#S"

      # Window and pane numbering
      set -g renumber-windows on
      setw -g pane-base-index 1

      # Behavior
      setw -g aggressive-resize on
      set -sg escape-time 0
      set -g display-time 2000
      set -g focus-events on

      # Terminal
      set -sa terminal-overrides ",*256col*:Tc"

      # Status bar
      set -g status-position bottom
      set -g status-interval 5
      set -g status-justify left

      # Colors (matching i3/polybar theme)
      set -g status-bg "#282A2E"
      set -g status-fg "#FFFFFF"

      setw -g window-status-current-style "fg=#282A2E,bg=#9ECE6A,bold"
      setw -g window-status-current-format " #I:#W "

      setw -g window-status-style "fg=#FFFFFF,bg=#373B41"
      setw -g window-status-format " #I:#W "

      setw -g window-status-activity-style "fg=#FACD76,bg=#282A2E"

      set -g pane-border-style "fg=#373B41"
      set -g pane-active-border-style "fg=#9ECE6A"

      set -g message-style "fg=#FFFFFF,bg=#373B41"

      set -g status-left "#{?client_prefix,#[fg=#FACD76#,bold] ⌨ #S ,#[fg=#9ECE6A#,bold] #S }#[default] "
      set -g status-left-length 20

      set -g status-right "#[fg=#FACD76]%d %b %H:%M "
      set -g status-right-length 50

      # Keybindings - Splits (preserve current path, matching i3 h/v pattern)
      bind h split-window -h -c "#{pane_current_path}"
      bind v split-window -v -c "#{pane_current_path}"

      # Keybindings - Navigation (arrow keys like i3)
      bind Left select-pane -L
      bind Down select-pane -D
      bind Up select-pane -U
      bind Right select-pane -R

      # Keybindings - Resize (Ctrl+arrows like i3, repeatable)
      bind -r C-Left resize-pane -L 5
      bind -r C-Down resize-pane -D 5
      bind -r C-Up resize-pane -U 5
      bind -r C-Right resize-pane -R 5

      # Keybindings - Quick window selection (like i3 workspaces)
      bind 1 select-window -t 1
      bind 2 select-window -t 2
      bind 3 select-window -t 3
      bind 4 select-window -t 4
      bind 5 select-window -t 5
      bind 6 select-window -t 6
      bind 7 select-window -t 7
      bind 8 select-window -t 8
      bind 9 select-window -t 9

      # Quick scrolling without explicit copy mode entry
      # Page-based scrolling (Shift+PageUp/Down)
      bind -n S-PageUp copy-mode -e \; send-keys -X page-up
      bind -T copy-mode-vi S-PageUp send-keys -X page-up
      bind -T copy-mode-vi S-PageDown send-keys -X page-down

      # Line-based scrolling (Shift+Up/Down)
      bind -n S-Up copy-mode -e \; send-keys -X scroll-up
      bind -T copy-mode-vi S-Up send-keys -X scroll-up
      bind -T copy-mode-vi S-Down send-keys -X scroll-down

      # Keybindings - Copy mode (vi-mode)
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection
      bind -T copy-mode-vi DoubleClick1Pane send-keys -X select-word \; send-keys -X copy-selection-no-clear

      # Clear screen and scrollback history
      bind k send-keys C-l \; clear-history

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
    '';
  };
}
