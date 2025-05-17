{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.disko.url = "github:nix-community/disko/latest";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, disko, nixpkgs }: {
    nixosConfigurations.mymachine = nixpkgs.legacyPackages.x86_64-linux.nixos [
      ./configuration.nix
      disko.nixosModules.disko
      {
        disko.devices = {
          disk = {
            main = {
              type = "disk";
              device = "/dev/vda";
              content = {
                type = "gpt";
                partitions = {
                  MBR = {
                    size = "1M";
                    type = "EF02"; # for grub MBR
                    priority = 1; # Needs to be first partition
                  };
                  ESP = {
                    size = "512M";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0077" ];
                    };
                  };
                  # ESP = {
                  #   size = "512M";
                  #   type = "EF00";
                  #   content = {
                  #     type = "filesystem";
                  #     format = "vfat";
                  #     mountpoint = "/boot";
                  #     mountOptions = [ "umask=0077" ];
                  #   };
                  # };
                  luks = {
                    size = "100%";
                    content = {
                      type = "luks";
                      name = "crypted";
                      # disable settings.keyFile if you want to use interactive password entry
                      #passwordFile = "/tmp/secret.key"; # Interactive
                      settings = {
                        allowDiscards = true;
                      #   keyFile = "/tmp/secret.key";
                      };
                      # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                      content = {
                        type = "btrfs";
                        extraArgs = [ "-f" ];
                        subvolumes = {
                          root = {
                            mountpoint = "/";
                            mountOptions = [
                              "compress=zstd"
                              "noatime"
                            ];
                          };
                          home = {
                            mountpoint = "/home";
                            mountOptions = [
                              "compress=zstd"
                              "noatime"
                            ];
                          };
                          nix = {
                            mountpoint = "/nix";
                            mountOptions = [
                              "compress=zstd"
                              "noatime"
                            ];
                          };
                          swap = {
                            mountpoint = "/.swapvol";
                            swap.swapfile.size = "20M";
                          };
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      }
    ];
  };
}