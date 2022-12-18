# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  console.useXkbConfig = true;

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
  };

  networking.hostName = "virhe"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  programs.light.enable = true;

  # sound.mediaKeys.enable = true;

  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"; }
      { keys = [ 114 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/pactl set-sink-volume @DEFAULT_SINK@ -5"; }
      { keys = [ 115 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/pactl set-sink-volume +5"; }
      { keys = [ 190 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle"; }
    ];
  };

  services.blueman.enable = true;

  # Configure X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    xkbOptions = "ctrl:swapcaps";
    libinput = {
      enable = true;
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
      ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tredontho = {
    isNormalUser = true;
    description = "Trevor Thompson";
    extraGroups = [ "networkmanager" "wheel" "video" "audio"];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp2s0";
  };
  programs.zsh.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
