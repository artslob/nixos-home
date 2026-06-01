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
      # fix for nix-shell and starship
      export STARSHIP_PREEXEC_READY=true;

      # Create backup of current git branch with incremental suffix
      gbak() {
        local current_branch
        current_branch=$(git rev-parse --abbrev-ref HEAD) || return 1

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
