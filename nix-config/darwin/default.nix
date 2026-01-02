# nix-config/darwin/default.nix
#
# 役割:
# - macOS「システム」レイヤーの定義のみを担当する
# - ユーザー環境の内容（dotfiles / CLI設定）は扱わない
#   - dotfiles → chezmoi
#   - CLI / user tools → home-manager
#
# 前提:
# - Determinate Nix を利用（nix.enable = false）
# - home-manager は nix-darwin 経由で使用
# - Homebrew は cask のみを管理

{
  config,
  pkgs,
  lib,
  identity,
  ...
}:

let
  username = identity.username;
in
{
  # ============================================================
  # nix-darwin / macOS 基本設定
  # ============================================================

  system.stateVersion = 5;
  system.primaryUser = username;
  nix.enable = false;

  # 非フリーソフトを許可（Homebrew cask / 一部パッケージ向け）
  nixpkgs.config.allowUnfree = true;

  # ============================================================
  # macOS Defaults
  # ============================================================

  # Finder で隠しファイル（ドットファイル）を常に表示
  system.defaults.finder.AppleShowAllFiles = true;
  # Finder の既定表示をカラム表示にする
  system.defaults.finder.FXPreferredViewStyle = "clmv";
  system.activationScripts.postActivation.text = lib.mkAfter ''
    /usr/bin/killall Finder >/dev/null 2>&1 || true
  '';

  # ============================================================
  # User / Shell
  # ============================================================

  # macOS 上のユーザー定義
  # dotfiles の中身は chezmoi が管理するため、ここでは最低限のみ
  users.users.${username} = {
    home = identity.homeDirectory;
    shell = pkgs.zsh;
  };

  # システムとして zsh を有効化
  programs.zsh.enable = true;

  # ============================================================
  # System Packages
  # ============================================================

  # system は最小構成に留める
  # CLI ツール類は home-manager 側で管理する
  environment.systemPackages = [ ];

  # ============================================================
  # Homebrew (GUI Apps Only)
  # ============================================================

  # Homebrew は GUI アプリ（cask）のみを管理
  homebrew = {
    enable = true;

    # darwin-rebuild 実行時の Homebrew 振る舞い
    onActivation = {
      # 定義済み cask の更新
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };

    # 管理対象のGUIアプリ, フォント一覧
    casks = [
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "zed"
      "font-udev-gothic-nf"
      "font-geist-mono-nerd-font"
      "font-source-han-code-jp"
    ];
  };
}
