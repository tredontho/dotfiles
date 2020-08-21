# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hostname"; # Define your hostname.
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
    wget vim_configurable git mkpasswd nmap tcpdump rxvt_unicode htop
    tmux
    irssi
    keepassx2
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

    zsh
    oh-my-zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.ssh.startAgent = true;

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    # Customize your oh-my-zsh options here
    ZSH_THEME="robbyrussell"
    plugins=(git docker)

    bindkey '\e[5~' history-beginning-search-backward
    bindkey '\e[6~' history-beginning-search-forward

    HISTFILESIZE=500000
    HISTSIZE=500000
    EDITOR=vim
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_DUPS
    setopt INC_APPEND_HISTORY
    autoload -U compinit && compinit
    unsetopt menu_complete
    unsetopt beep
    setopt completealiases
    bindkey -v

    if [ -f ~/.aliases ]; then
      source ~/.aliases
    fi

    source $ZSH/oh-my-zsh.sh
  '';
  programs.zsh.promptInit = "";


  # List services that you want to enable:

  # Start with `systemctl start openvpn-<name>.service`
  services.openvpn.servers = {
    pia = {
      autoStart = false;
      config = '' config /home/<username>/openvpn/pia.conf '';
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:swapcaps";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;
  # services.xserver.synaptics = {
  services.xserver.libinput = {
    enable = true;
    disableWhileTyping = true;
    sendEventsMode = "disabled-on-external-mouse";
  };

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager = {
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  users.extraUsers.tredontho = {
    isNormalUser = true;
    home = "/home/tredontho";
    description = "First Last";
    extraGroups = ["wheel" "networkmanager" "audio"];
    hashedPassword = "mkPasswd result";
    initialHashedPassword = "same as above?";
    shell = pkgs.zsh;
  };
  users.mutableUsers = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
