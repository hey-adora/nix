{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.disko.url = "github:nix-community/disko/latest";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self,  disko, nixpkgs, home-manager }: {
    nixosConfigurations.mymachine = nixpkgs.legacyPackages.x86_64-linux.nixos [
      disko.nixosModules.disko
      {
        nixosConfigurations = {
          # FIXME replace with your hostname
          adora = nixpkgs.lib.nixosSystem {
            # specialArgs = {inherit inputs outputs;};
            # > Our main nixos configuration file <
            modules = [./configuration.nix];
          };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#your-username@your-hostname'
        homeConfigurations = {
          # FIXME replace with your username@hostname
          "hey@adora" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            # extraSpecialArgs = {inherit inputs outputs;};
            # > Our main home-manager configuration file <
            modules = [./home.nix];
          };
        };
      }
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