# nix-config/darwin/default.nix
{ config, pkgs, lib, identity, ... }:

let
  username = identity.username;
in
{
  system.stateVersion = 5;

  # nix-darwin 変更対応: homebrew 等の primary-user オプションの適用先
  system.primaryUser = username;

  # Determinate Nix を使う前提
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  # Determinate で既に有効化済みであることが多いので、必要になったら明示
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.${username} = {
    home = identity.homeDirectory;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Zenn 記事寄せ: system は最小にして、CLI ツール類は home-manager に寄せる
  environment.systemPackages = [ ];

  # Homebrew は cask のみ
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };

    casks = [
      "ghostty"
      "karabiner-elements"
      "zed"
    ];
  };
}
