{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.zen-browser.url = "github:0xc000022070/zen-browser-flake";

  outputs = { self, nixpkgs, zen-browser, ... }@inputs: {
    # FIXME change hostname
    nixosConfigurations.adora = nixpkgs.lib.nixosSystem {
      #system = "x86_64-linux";
      specialArgs = {inherit inputs; };
      modules = [ 
          ./configuration.nix
        ];
    };
  };
}
