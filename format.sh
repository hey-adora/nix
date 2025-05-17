#!/bin/sh

sudo mount -o remount,size=10G,noatime /nix/.rw-store
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disk.nix