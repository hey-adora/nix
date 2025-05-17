#!/bin/sh

sudo mount -o remount,size=10G,noatime /nix/.rw-store
nixos-generate-config --root . --no-filesystems
mv ./etc/nixos/configuration.nix ./configuration.nix
mv ./etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
rmdir ./etc/nixos
rmdir ./etc
#sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disk.nix
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake '.#mymachine' --disk main /dev/vda