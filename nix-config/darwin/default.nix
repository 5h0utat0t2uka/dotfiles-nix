# nix-config/darwin/default.nix
{ config, pkgs, lib, identity, ... }:

let
  username = identity.username;
in
{
  system.stateVersion = 5;

  # nix-darwin 変更対応: homebrew 等の primary-user オプションの適用先
  system.primaryUser = username;

  nix.enable = false;
  nixpkgs.config.allowUnfree = true;
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.${username} = {
    home = identity.homeDirectory;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
  ];

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
