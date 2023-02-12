# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "artslob-laptop";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Bangkok";

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+i3";
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3lock
        rofi
        (polybar.override {
          i3GapsSupport = true;
          pulseSupport = true;
        })
      ];
    };

    layout = "us,ru";
    xkbOptions = "grp:toggle,ctrl:nocaps";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.artslob = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    initialHashedPassword =
      "$y$j9T$uylUKYwGtMuGI4HO0QwvW/$EP2GGktreuKC09uvUEMzfTEcqNLJHpbULU7wx8ZZy93";
  };
  security.sudo.extraRules = [{
    users = [ "artslob" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" "SETENV" ];
    }];
  }];

  home-manager.users.artslob = { pkgs, ... }: {
    home.stateVersion = "22.11";
    programs.bash = {
      enable = true;
      bashrcExtra = ''
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
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
    chromium
    git
    htop
    nixfmt
    pre-commit
    openvpn
    bitwarden
    alacritty
    tdesktop # telegram
    stow
    shutter
    starship
    gparted
    networkmanagerapplet
    libsForQt5.dolphin
    feh # image viewer
    nomacs # image viewer
    libsForQt5.okular # pdf viewer
    python3
    xdotool # script for alacritty
    arandr
    moreutils # sponge bash command
    neofetch
    docker-compose
    libreoffice
    dunst # notifications
    smplayer
    jetbrains.idea-community
    vscodium
    dbeaver
  ];

  # keyring keeps passwords, e.g. for nm-applet
  services.gnome.gnome-keyring.enable = true;

  virtualisation.docker.enable = true;

  # i3 tips: help settings to be saved for applications (gtk3 applications, firefox),
  # like the size of file selection windows, or the size of the save dialog
  programs.dconf.enable = true;

  programs.ssh.startAgent = true;

  fonts.fonts = with pkgs; [
    # terminal
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # window manager workspace bar icons
    font-awesome
    # window manager workspace bar text
    jetbrains-mono
  ];

  programs.bash.shellAliases = {
    p = "pwd";
    g = "git";
  };
  programs.bash.undistractMe.enable = true;

  programs.git = {
    enable = true;
    config = {
      core.editor = "vim";
      init.defaultBranch = "main";
      alias = {
        a = "add";
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
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

