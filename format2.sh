#!/bin/sh

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disk-config_2.nix 
sudo nixos-generate-config --root /mnt
