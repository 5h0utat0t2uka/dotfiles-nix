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

  outputs =
    { self, nixpkgs, home-manager, darwin, ... }:
    let
      identity = import ./identity.nix;

      system = identity.system;
      username = identity.username;
      hostname = identity.hostname;
    in
    {
      # nix-darwin 経由で home-manager を使う（standalone を outputs に出さない）
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        inherit system;

        # module 側から identity を参照できるようにする
        specialArgs = { inherit identity; };

        modules = [
          # nixpkgs 設定（allowUnfree など）を darwin 側へ注入
          {
            nixpkgs = {
              inherit system;
              config.allowUnfree = true;
            };
          }

          # nix-darwin (system)
          ./darwin/default.nix

          # home-manager を nix-darwin 経由で統合
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = { inherit identity; };

            # HM user 定義
            home-manager.users.${username} = import ./darwin/home.nix;
          }
        ];
      };

      # darwin.sh が "#default" を叩く前提を維持
      # default = self.darwinConfigurations.${hostname};
    };
}
