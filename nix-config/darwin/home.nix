# nix-config/darwin/home.nix
{ pkgs, identity, ... }:

{
  home.username = identity.username;
  home.homeDirectory = identity.homeDirectory;

  # HM の互換性基準（固定）
  home.stateVersion = "25.11";

  # 重要: dotfile の実体は chezmoi が管理する前提なので HM では生成しない
  programs.zsh.enable = false;
  programs.git.enable = false;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    # bootstrap / dotfile 運用
    chezmoi
    just

    # 開発用CLI（user層）
    git
    gh
    ghq
    neovim
    starship
    delta
    ripgrep
    fd
    fzf
    jq
    bat
    eza
    zoxide
    tree
    wget
    lazygit
    gnupg
    pass
    passExtensions.pass-otp
    pinentry_mac
  ];
}
