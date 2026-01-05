{ config, pkgs, lib, identity, ... }:

let
  username = identity.username;
in
{
  # ============================================================
  # nix-darwin / macOS 基本設定
  # ============================================================
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 5;
  system.primaryUser = username;

  # ============================================================
  # macOS Defaults
  # ============================================================
  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.FXPreferredViewStyle = "clmv";
  system.activationScripts.postActivation.text = lib.mkAfter ''
    /usr/bin/killall Finder >/dev/null 2>&1 || true
  '';

  # ============================================================
  # User / Shell
  # ============================================================

  users.users.${username} = {
    home = identity.homeDirectory;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # ============================================================
  # System Packages
  # ============================================================

  environment.systemPackages = [ ];

  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    source-han-code-jp
  ];
}
