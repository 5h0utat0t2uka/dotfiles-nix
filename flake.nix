# flake.nix
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

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }:
    let
      # identity.nix は Git 管理している前提（flake evaluation で必須）
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
      # --- Phase B: home-manager (CLI only) ---
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit identity; };

        modules = [
          ./nix-config/darwin/home.nix
        ];
      };

      # --- Phase C+: nix-darwin (optional / last) ---
      # 推奨: hostname をキーにする（例: A3112）
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit identity; };

        modules = [
          ./nix-config/darwin/default.nix

          home-manager.darwinModules.home-manager
          {
            nixpkgs = { inherit pkgs; };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit identity; };
            home-manager.users.${username} = import ./nix-config/darwin/home.nix;
          }
        ];
      };

      # 互換: 以前の default を使いたい場合
      darwinConfigurations.default = self.darwinConfigurations.${hostname};
    };
}
