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
    { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      hostKey = "A3112";
      identity = import ./hosts/darwin/${hostKey}/identity.nix;

      system = identity.system;
      username = identity.username;
      hostname = identity.hostname;
    in
    {
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        inherit system;

        # modules 側でも identity を参照できるようにする
        specialArgs = { inherit identity inputs; };

        modules = [
          # nixpkgs 設定（allowUnfree など）
          {
            nixpkgs = {
              inherit system;
              config.allowUnfree = true;
            };
          }

          # home-manager を nix-darwin 経由で統合
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # home-manager 側にも identity を渡す（あなたの既存 home-manager.nix が identity を要求）
            home-manager.extraSpecialArgs = { inherit identity; };

            # HM user 定義（home-manager.nix 側で home.username 等を設定）
            home-manager.users.${username} = import ./modules/darwin/home-manager.nix;
          }

          # ホスト入口（imports で system/homebrew を読む）
          ./hosts/darwin/${hostKey}/default.nix
        ];
      };
    };
}
