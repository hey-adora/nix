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
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, ... }@ inputs: let
    inherit (self) outputs; in {
    nixosConfigurations.adora = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs outputs };
      modules = [ ./configuration.nix ];
    };
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "hey@adora" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home.nix];
      };
    };
  };
}
