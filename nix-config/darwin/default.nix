# nix-config/darwin/default.nix
{ config, pkgs, lib, identity, ... }:

let
  username = identity.username;

  # homebrew-casks.txt を Nix で読む版（任意）
  # - 空行/コメント(#)を除外
  # - Phase D で手で書く運用でもOK
  caskFile = ../../config/homebrew-casks.txt;
  casksFromFile =
    if builtins.pathExists caskFile then
      let
        lines = lib.splitString "\n" (builtins.readFile caskFile);
        trimmed = map lib.strings.trimString lines;
      in
      builtins.filter (s: s != "" && !(lib.hasPrefix "#" s)) trimmed
    else
      [ ];
in
{
  # nix-darwin のバージョン固定（導入時点の値でOK）
  system.stateVersion = 5;

  nixpkgs.config.allowUnfree = true;

  # Nix 設定
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ユーザ（nix-darwin 導入後のみ必要）
  users.users.${username} = {
    home = identity.homeDirectory;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # 基本ツール（OS側で欲しいものだけ）
  environment.systemPackages = with pkgs; [
    git
  ];

  # Homebrew を nix-darwin で宣言管理（Phase D/E）
  homebrew = {
    enable = true;

    # Apple Silicon / Intel 両対応（どちらかに寄せたいなら片方だけでも可）
    onActivation = {
      autoUpdate = true;
      upgrade = true;

      # Phase D: まずは none のまま（削除しない）
      # Phase E: "uninstall" にして宣言外を削除、十分慣れてから "zap"
      cleanup = "none";
    };

    # GUI アプリ（cask）
    # Phase D 運用:
    # 1) まずは homebrew-casks.txt から読み取りで埋める（この casksFromFile）
    # 2) 安定したら default.nix に直書きへ移行でもOK
    casks = casksFromFile;

    # 例: 直書きにするならこう
    # casks = [
    #   "ghostty"
    #   "google-chrome"
    #   "visual-studio-code"
    #   "zed"
    # ];

    # brew formula（必要なら）
    # brews = [ "mas" "wget" ];
    # taps = [ "homebrew/cask" ];
  };

  # macOS defaults を触りたい場合はここに追加（任意）
  # system.defaults.dock.autohide = true;
}
