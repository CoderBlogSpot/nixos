# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     /etc/nixos/hardware-configuration.nix
    ];

  environment.variables = {
	SUDO_EDITOR = "nvim";      
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "hackerbox";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.qtile.enable = true;
  services.xserver.displayManager = {
      lightdm.enable = true;
      autoLogin = {
	        enable = true;
          user = "chrizelle";
      };
  };

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.picom.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.dbus.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.chrizelle = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim
     wget
     curl
     xfce.thunar
     sublime4
     google-chrome
     htop
     neofetch
     git
     picom
     kitty
     rofi
     pavucontrol
     alsa-utils
     redshift
     lxappearance
     unzip
     obsidian
     flameshot
     nodejs
     python310Packages.pip
     xarchiver
     fontconfig
     polkit_gnome
     brightnessctl
     jetbrains-mono
     dbus-next
   ];

 security.polkit.enable = true;
 systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
   extraConfig = ''
     DefaultTimeoutStopSec=10s
   '';
  };

  # Auto upgrades
  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  system.stateVersion = "23.05"; # Did you read the comment?

}
