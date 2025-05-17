#!/bin/sh

nixos-generate-config --root . --no-filesystems
mv ./etc/nixos/configuration.nix ./configuration.nix
mv ./etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
rmdir ./etc/nixos
rmdir ./etc