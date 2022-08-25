# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    # "nvidia-x11"
    # "nvidia-settings"
  # ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "monoid"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget vim_configurable git mkpasswd nmap tcpdump rxvt_unicode bottom curl
    neovim
    tmux
    irssi
    maim
    
    chromium
    firefox
    trayer
    haskellPackages.xmobar

    xfontsel
    xlsfonts
    xorg.xbacklight
    xbindkeys
    xbindkeys-config

    dmenu
    xscreensaver
    xclip

    bc
    unzip
    tree

  ];


  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # programs.ssh.startAgent = true;
  # programs.zsh.enable = true;


  # List services that you want to enable:

  # Start with `systemctl start openvpn-<name>.service`
  services.openvpn.servers = {
    pia = {
      autoStart = false;
      config = '' config /home/tredontho/openvpn/pia.conf '';
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:swapcaps";
    # videoDrivers = [ "nvidia" ];

    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };

    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+xmonad";
    };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  users.extraUsers.tredontho = {
    isNormalUser = true;
    home = "/home/tredontho";
    description = "Trevor Thompson";
    extraGroups = ["wheel" "networkmanager" "audio" "docker"];
    shell = pkgs.zsh;
    hashedPassword = "$6$oUnoYBhnke$ceyJtWtBWQb8HpDQLR3cWTEFAWo9QNMXwvTu5TUVW0ajZ.UD1HpKPLRyvj6IFelaHr7q57/gFZT8sjkO8aekY.";
    initialHashedPassword = "$6$oUnoYBhnke$ceyJtWtBWQb8HpDQLR3cWTEFAWo9QNMXwvTu5TUVW0ajZ.UD1HpKPLRyvj6IFelaHr7q57/gFZT8sjkO8aekY.";
  };
  users.mutableUsers = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?

}
