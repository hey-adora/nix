# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, nixpkgs, inputs, ... }: {
  # do something with home-manager here, for instance:
  imports = [  ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.auto-optimise-store = true;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  # boot.loader.grub.useOSProber = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;

  # FIXME: Replace with your username
  users.users.hey = {
    initialPassword = "home";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
    extraGroups = ["wheel"];
  };

  networking.hostName = "adora"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  system.stateVersion = "25.05"; # Did you read the comment?
}
