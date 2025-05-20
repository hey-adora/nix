# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  zramSwap.enable = true;

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.auto-optimise-store = true;

  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  # ];

  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.open = true;
  hardware.nvidia.nvidiaSettings = true;

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # For 32 bit applications

  boot.kernelParams = [
    "radeon.si_support=0"
    "amdgpu.si_support=1"
    "radeon.cik_support=0"
    "amdgpu.cik_support=1"
  ];

  # Use the GRUB 2 boot loader.
  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_3_10;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.enableCryptodisk = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
    "/boot/hddkey" = null;
  };

  boot.initrd.luks.devices.crypted.keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices.hdd3.keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices.hdd1.keyFile = "/boot/hddkey";
  boot.initrd.luks.devices.hdd2.keyFile = "/boot/hddkey";

  # fileSystems."/mnt/hdd1".depends = [ "/" ];
  #fileSystems."/mnt/hdd1".pass = 2;

  networking.hostName = "adora"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-browser-connector.enable = true;

  services.flatpak.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "hey" ];
  virtualisation.libvirtd.enable = true;

  users.users.hey = {
    initialPassword = "home";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      home-manager
    ];
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #wget
    zsh
    git
    wl-clipboard
    clinfo
    vulkan-tools
    # blender-hip
  ];

  # environment.etc.crypttab.mode = "0600";
  # environment.etc.crypttab.text = ''
  #   hdd3           UUID=3466d7cf-6769-43e2-9293-2080eca0cd47    /boot/crypto_keyfile.bin
  #   hdd1           UUID=a45f1e82-bf48-4b38-8481-84a442cfa31f    /boot/hddkey
  #   hdd2           UUID=9b46e655-a653-4683-8cfa-d21c5e08fdaf    /boot/hddkey
  # '';

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

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
