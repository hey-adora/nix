#!/bin/sh
lsblk
# echo "select /dev/<disk>: "
# read $disk
# sudo mount -o remount,size=10G,noatime /nix/.rw-store
# rm -r /tmp/config
# nixos-generate-config --root /tmp/config --no-filesystems
# rm /tmp/config/etc/nixos/configuration.nix 
# cp configuration.nix /tmp/config/etc/nixos/configuration.nix
# cp flake.nix /tmp/config/etc/nixos/flake.nix
# sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake '/tmp/config/etc/nixos#adora' --disk main /dev/$disk --extra-files /tmp/config/etc/nixos/flake.nix /etc/nixos/flake.nix --extra-files /tmp/config/etc/nixos/configuration.nix /etc/nixos/configuration.nix --extra-files /tmp/config/etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disk-config.nix 
sudo nixos-generate-config --root /mnt
sudo rm /mnt/etc/nixos/configuration.nix
sudo cp configuration.nix /mnt/etc/nixos/configuration.nix
sudo cp home.nix /mnt/etc/nixos/home.nix
sudo cp flake.nix /mnt/etc/nixos/flake.nix
sudo nixos-install