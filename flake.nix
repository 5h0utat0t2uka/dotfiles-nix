{
  description = "dotfiles-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }:
    let
      identity = import ./config/identity.nix;

      system = identity.system;
      username = identity.username;
      hostname = identity.hostname;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit identity; };
          modules = [
            ./nix-config/darwin/home.nix
          ];
        };
      };

      darwinConfigurations = {
        "${hostname}" = darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit identity; };
          modules = [
            { nixpkgs = { inherit system; config.allowUnfree = true; }; }

            ./nix-config/darwin/default.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit identity; };
              home-manager.users."${username}" = import ./nix-config/darwin/home.nix;
            }
          ];
        };

        # darwin.sh が "#default" を叩くため必ず alias を用意
        default = self.darwinConfigurations."${hostname}";
      };
    };
}
