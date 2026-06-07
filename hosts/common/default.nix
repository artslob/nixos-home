# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Automatically collect garbage weekly, removing generations older than 3 months.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 90d";
    persistent = true; # run on next boot if the machine was off at the scheduled time
  };

  # Deduplicate the store: hard-link identical files on every build, plus a weekly sweep.
  nix.settings.auto-optimise-store = true;
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    # Limit generations as boot entries so the small EFI partition doesn't fill up.
    systemd-boot.configurationLimit = 30;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  time.timeZone = "Asia/Tel_Aviv";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
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

  # Enable sound via PipeWire (with ALSA and PulseAudio compatibility).
  # rtkit lets PipeWire's audio threads acquire realtime scheduling priority.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.mutableUsers = false;
  users.users.artslob = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    hashedPasswordFile = config.age.secrets.artslob-password-hash.path;
  };
  security.sudo.extraRules = [
    {
      users = [ "artslob" ];
      commands = [
        {
          command = "ALL";
          options = [
            "NOPASSWD"
            "SETENV"
          ];
        }
      ];
    }
  ];
  age.secrets.artslob-password-hash.file = ../../secrets/artslob-password-hash.age;

  environment.systemPackages = with pkgs; [
    vim
    wget
    chromium
    git
    age
    agenix-cli
    gnupg
    htop
    nixfmt
    nixfmt-tree
    pre-commit
    openvpn
    wireguard-tools # wg-quick for VPN
    unstable.bitwarden-desktop
    alacritty
    telegram-desktop
    stow
    shutter
    starship
    gparted
    networkmanagerapplet
    kdePackages.dolphin # file manager
    nautilus # file manager
    feh # image viewer
    nomacs # image viewer
    kdePackages.okular # pdf viewer
    python3
    rustup
    gcc
    xdotool # script for alacritty
    arandr
    moreutils # sponge bash command
    killall
    jq
    fastfetch
    docker-compose
    libreoffice
    dunst # notifications
    smplayer # video player
    vlc # video player
    pavucontrol
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
    simplescreenrecorder
    obs-studio # screen recorder
    unstable.gemini-cli
    claude-code
    unstable.cursor-cli
  ];

  # keyring keeps passwords, e.g. for nm-applet
  services.gnome.gnome-keyring.enable = true;
  # disabled because of conflict with `programs.ssh.startAgent`
  services.gnome.gcr-ssh-agent.enable = false;

  virtualisation.docker.enable = true;

  # i3 tips: help settings to be saved for applications (gtk3 applications, firefox),
  # like the size of file selection windows, or the size of the save dialog
  programs.dconf.enable = true;

  programs.ssh.startAgent = true;

  # sshd runs on every host so NixOS generates/persists the host key in
  # /etc/ssh, which agenix uses as its decryption identity (age.identityPaths).
  # The daemon is hardened and not exposed: openFirewall is off, so a host only
  # accepts SSH if it explicitly opens port 22 (see loq's wg0 rule).
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  programs.firefox.enable = true;

  # Send files in local network.
  # The module opens TCP/UDP 53317 (openFirewall defaults to true).
  programs.localsend.enable = true;

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

  # Laptop lid switch behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend"; # Suspend when on battery
    HandleLidSwitchExternalPower = "ignore"; # Ignore when plugged in
    HandleLidSwitchDocked = "ignore"; # Ignore when docked
  };

  # Enable numlock on console TTY (before graphical session)
  systemd.services."getty@".serviceConfig.ExecStartPre = [ "-${pkgs.kbd}/bin/setleds -D +num" ];

  services.v2raya = {
    enable = true;
    cliPackage = pkgs.xray; # Recommended for better protocol support (like VLESS/Reality)
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
}
