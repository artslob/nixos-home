# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hostConfig, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  time.timeZone = "Asia/Tel_Aviv";

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3lock
        i3blocks
        rofi
        (polybar.override {
          i3Support = true;
          pulseSupport = true;
        })
        brightnessctl
      ];
    };

    xkb = {
      layout = "us,ru";
      options = "grp:toggle,ctrl:nocaps";
    };
  };

  services.displayManager.defaultSession = "none+i3";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable sound.
  # Conflicting with pipewire
  # sound.enable = true;
  # pulseaudio.enable = true;
  # hardware.pulseaudio.enable = true;

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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "zoom" "slack" ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
    chromium
    git
    gnupg
    htop
    nixfmt-classic
    pre-commit
    openvpn
    wireguard-tools # wg-quick for VPN
    bitwarden
    alacritty
    tdesktop # telegram
    stow
    shutter
    starship
    gparted
    networkmanagerapplet
    libsForQt5.dolphin # file manager
    nautilus # file manager
    feh # image viewer
    nomacs # image viewer
    libsForQt5.okular # pdf viewer
    python3
    rustup
    gcc
    xdotool # script for alacritty
    arandr
    moreutils # sponge bash command
    killall
    neofetch
    docker-compose
    libreoffice
    dunst # notifications
    smplayer # video player
    vlc # video player
    pavucontrol
    jetbrains.idea-community
    vscodium
    dbeaver-bin
    zoom-us
    slack
    zip
    unzip
    p7zip
    unar
    libheif # heif-convert command
    imagemagick # convert command
    bat
    tree
  ];

  # keyring keeps passwords, e.g. for nm-applet
  services.gnome.gnome-keyring.enable = true;

  virtualisation.docker.enable = true;

  # i3 tips: help settings to be saved for applications (gtk3 applications, firefox),
  # like the size of file selection windows, or the size of the save dialog
  programs.dconf.enable = true;

  programs.ssh.startAgent = true;

  fonts.packages = with pkgs; [
    # terminal
    nerd-fonts.jetbrains-mono
    # window manager workspace bar icons
    font-awesome
    # window manager workspace bar text
    jetbrains-mono
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

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
  system.stateVersion = hostConfig.stateVersion; # Did you read the comment?
}
