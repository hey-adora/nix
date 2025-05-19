{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.home-manager.url = github:nix-community/home-manager;
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.zen-browser.url = "github:0xc000022070/zen-browser-flake";

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }@inputs: {
    # FIXME change hostname
    nixosConfigurations.adora = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs };
      modules = [ 
          ./configuration.nix
          home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # FIXME change username
            home-manager.users.hey = import ./home.nix;
            home-manager.extraSpecialArgs = {
            
              # bring in the list of inputs into the home-manager module
              inherit inputs;
              system = "x86_64-linux";
            };
          }
        ];
    };
  };
}
