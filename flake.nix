# {
#   inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
#   inputs.disko.url = "github:nix-community/disko/latest";
#   inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

#   outputs = { self,  disko, nixpkgs }: {
#     nixosConfigurations.adora = nixpkgs.legacyPackages.x86_64-linux.nixos [
#       ./configuration.nix
#       disko.nixosModules.disko
#     ];
#   };
# }
{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager.url = github:nix-community/home-manager;

  outputs = { self, nixpkgs, home-manager, ... }@attrs: {
    nixosConfigurations.fnord = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
