{
  description = "dotfiles-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, ... } @inputs:
    let
      lib = nixpkgs.lib;

      # ./hosts/darwin 配下のディレクトリ名（= hostKey）を列挙
      darwinHostsDir = ./hosts/darwin;
      darwinHostKeys = lib.attrNames(lib.filterAttrs (_name: type: type == "directory")(builtins.readDir darwinHostsDir));

      identityFor = hostKey: import (darwinHostsDir + "/${hostKey}/identity.nix");
      mkDarwinConfig = hostKey:
        let
          identity = identityFor hostKey;
        in
        # 方式Aの前提：ディレクトリ名と identity.hostname を一致させる
        assert (identity ? hostname);
        assert (identity.hostname == hostKey);
        {
          name = identity.hostname;
          value = darwin.lib.darwinSystem {
            system = identity.system;
            specialArgs = { inherit identity inputs; };
            modules = [
              # nixpkgs 設定
              {
                nixpkgs = {
                  system = identity.system;
                  config.allowUnfree = true;
                  overlays = [
                    (import ./overlays/fonts/shcode-jp-zen-haku.nix)
                  ];
                };
              }

              nix-homebrew.darwinModules.nix-homebrew
              ({ identity, ... }: {
                nix-homebrew = {
                  enable = true;
                  enableRosetta = false;
                  user = identity.username;
                  autoMigrate = identity.hasExistingHomebrew or false;
                  mutableTaps = true;
                };
              })

              # home-manager を nix-darwin 経由で統合
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                # 既存 home-manager.nix が identity を要求する前提
                home-manager.extraSpecialArgs = { inherit identity; };
                home-manager.users.${identity.username} = import ./modules/darwin/home-manager.nix;
              }
              # ホスト入口（imports で system/homebrew を読む）
              (darwinHostsDir + "/${hostKey}/default.nix")
            ];
          };
        };

      darwinConfigurations = builtins.listToAttrs (map mkDarwinConfig darwinHostKeys);
    in
    {
      inherit darwinConfigurations;
      # 任意：フォーマッタ（ある環境だけで有効化したいなら消してOK）
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
}
