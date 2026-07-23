{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./i3.nix
    ./polybar.nix
    ./tmux.nix
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      p = "pwd";
      g = "git";
      l = "ls -l";
      ll = "ls -alh";
      t = "tmux";
      ta = "tmux attach -t";
      tn = "tmux new -s";
      tl = "tmux list-sessions | sort -V | nl -ba";
    };
    bashrcExtra = ''
      # Create backup of current git branch with incremental suffix
      gbak() {
        local current_branch
        current_branch=$(git rev-parse --abbrev-ref HEAD) || return 1

        # Don't create a duplicate: if a backup of this branch already points
        # at the current commit, report it and stop.
        local existing
        existing=$(git for-each-ref --points-at HEAD --format='%(refname:short)' "refs/heads/''${current_branch}.backup-*" | head -n1)
        if [ -n "$existing" ]; then
          echo "Backup already exists at current commit: $existing"
          return 0
        fi

        local counter=1
        local backup_name="''${current_branch}.backup-''${counter}"

        while git show-ref --verify --quiet "refs/heads/''${backup_name}"; do
          ((counter++))
          backup_name="''${current_branch}.backup-''${counter}"
        done

        git branch "$backup_name"
        echo "Created backup branch: $backup_name"
      }

      # Attach to tmux session by index (1-based)
      # Usage: tai <index>
      tai() {
        if [ -z "$1" ]; then
          echo "Usage: tai <index>" >&2
          return 1
        fi
        local index="$1"
        local session
        session=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | sort -V | sed -n "''${index}p")
        if [ -z "$session" ]; then
          echo "No session at index $index" >&2
          return 1
        fi
        if [ -n "$TMUX" ]; then
          tmux switch-client -t "$session"
        else
          tmux attach -t "$session"
        fi
      }

      [ -r ~/.bashrc-extra ] && . ~/.bashrc-extra
    '';
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
  };

  xsession.enable = true;

  # Enable numlock when X session starts
  xsession.numlock.enable = true;

  home.packages = with pkgs; [
    # useful to check names of gtk icons/themes
    lxappearance
    # for amixer
    alsa-utils
  ];

  # System-wide default editor for interactive tools (git falls back to this
  # too, though git.nix also sets core.editor explicitly).
  home.sessionVariables.EDITOR = "vim";

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

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Modern shell history search (replaces Ctrl+R with an interactive search).
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    daemon.enable = true;
    settings = {
      enter_accept = true;
      filter_mode_shell_up_key_binding = "directory";
      # Ctrl+A is atuin's prefix key by default (a two-step chord), which
      # shadows the classic "jump to start of line". Restore Ctrl+A to
      # cursor-start and move the prefix to Ctrl+X.
      #
      # NOTE: once any [keymap.*] setting exists, atuin ignores the entire [keys] section.
      keymap.emacs = {
        "ctrl-a" = "cursor-start";
        "ctrl-x" = "enter-prefix-mode";
      };
    };
  };

  services.dunst.enable = true;

  services.blueman-applet.enable = true;

  # CopyQ clipboard manager (history browsing). Opened via Mod4+c, see i3.nix.
  services.copyq.enable = true;

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
    setSessionVariables = true;
    createDirectories = true;
    desktop = null;
    publicShare = null;
    templates = null;
  };
}
