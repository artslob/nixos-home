# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "artslob-laptop";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # i3-gaps window manager
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  # Configure keymap in X11
  services.xserver.layout = "us,ru";
  services.xserver.xkbOptions = "grp:toggle,caps:ctrl_modifier";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.artslob = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    initialHashedPassword =
      "$y$j9T$uylUKYwGtMuGI4HO0QwvW/$EP2GGktreuKC09uvUEMzfTEcqNLJHpbULU7wx8ZZy93";
    #   packages = with pkgs; [
    #     firefox
    #     thunderbird
    #   ];
  };
  security.sudo.extraRules = [{
    users = [ "artslob" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" "SETENV" ];
    }];
  }];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    tdesktop
    stow
    (polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    })
    i3-gaps
    i3lock
    shutter
    rofi
    starship
    gparted
    networkmanagerapplet
    libsForQt5.dolphin
    feh # image viewer
    nomacs # image viewer
    libsForQt5.okular # pdf viewer
    python3
  ];

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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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

