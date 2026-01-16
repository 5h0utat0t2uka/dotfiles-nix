{
  # ============================================================
  # - darwinConfigurations は ./hosts/darwin 配下のホスト名のディレクトリから自動生成する
  # - 各 host は `./hosts/darwin/<ホスト名>/identity.nix` を持ち、その `identity.hostname` が <ホスト名> と一致することを `assert` で強制する
  # - setup.sh / Justfile から `darwin-rebuild` を呼ぶと、対象ホスト名の modules が合成されて switch/build される
  # ============================================================

  description = "dotfiles-nix";

  inputs = {
    # nixpkgs（unstable）
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nix-homebrew（nix 経由で Homebrew を管理）
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # home-manager（nixpkgs は flake の nixpkgs に追従させる）
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-darwin（nixpkgs は flake の nixpkgs に追従させる）
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 最新バージョンのclaude codeを取り込む
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, ... } @inputs:
  let
    lib = nixpkgs.lib;
    # ------------------------------------------------------------
    # ./hosts/darwin 以下のディレクトリ名を hostKey とする
    # ------------------------------------------------------------
    darwinHostsDir = ./hosts/darwin;

    darwinHostKeys =
      lib.attrNames
        (lib.filterAttrs (_name: type: type == "directory")
          (builtins.readDir darwinHostsDir));

    # ------------------------------------------------------------
    # hostKey から identity を読み込む
    # ------------------------------------------------------------
    identityFor = hostKey: import (darwinHostsDir + "/${hostKey}/identity.nix");

    # ------------------------------------------------------------
    # hostKey -> darwinConfigurations.<hostKey> を生成する関数
    # - ディレクトリ名と identity.hostname を assert で強制して一致させる
    # ------------------------------------------------------------
    mkDarwinConfig = hostKey:
      let
        identity = identityFor hostKey;
      in
      # identity に hostname があること、かつ hostKey と一致することを強制
      assert (identity ? hostname);
      assert (identity.hostname == hostKey);

      {
        name = identity.hostname;
        # nix-darwin のシステム定義
        value = darwin.lib.darwinSystem {
          system = identity.system;
          specialArgs = { inherit identity inputs; };
          modules = [
            # ----------------------------------------------------
            # nixpkgs 設定
            # ----------------------------------------------------
            {
              nixpkgs = {
                system = identity.system;
                config.allowUnfree = true;
                # 直接インストールが必要なパッケージの overlay をここで追加
                overlays = [
                  (import ./overlays/fonts/shcode-jp-zen-haku.nix)
                  (import ./overlays/tools/keifu.nix {})
                  (import ./overlays/tools/claude-code.nix { inherit inputs; })
                ];
              };
            }

            # ----------------------------------------------------
            # nix-homebrew 統合
            # - autoMigrate: 既存 Homebrew がある場合の移行
            # ----------------------------------------------------
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

            # ----------------------------------------------------
            # home-manager を nix-darwin 経由で統合
            # ----------------------------------------------------
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit identity; };
              home-manager.users.${identity.username} = import ./modules/darwin/home-manager.nix;
            }

            # ----------------------------------------------------
            # ホスト入口:
            # ----------------------------------------------------
            (darwinHostsDir + "/${hostKey}/default.nix")
          ];
        };
      };

    # ------------------------------------------------------------
    # 全 hostKey について mkDarwinConfig を map して attrset 化
    # ------------------------------------------------------------
    darwinConfigurations = builtins.listToAttrs (map mkDarwinConfig darwinHostKeys);
  in
  {
    inherit darwinConfigurations;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
  };
}
