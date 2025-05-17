#!/bin/sh

sudo mount -o remount,size=10G,noatime /nix/.rw-store
nixos-generate-config --root /tmp/config --no-filesystems
rm /tmp/config/etc/nixos/configuration.nix 
cp configuration.nix /tmp/config/etc/nixos/configuration.nix
cp flake.nix /tmp/config/etc/nixos/flake.nix
# mv ./etc /tmp/config/etc
# mv ./etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
# rmdir ./etc/nixos
# rmdir ./etc
#sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disk.nix
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake '/tmp/config/etc/nixos#mymachine' --disk main /dev/vda