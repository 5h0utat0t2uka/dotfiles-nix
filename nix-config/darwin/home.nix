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
    nixd
    nil
    bat
    chezmoi # 初回curl経由で入れるので消す予定
    delta
    eza
    fd
    fzf
    git
    gh
    ghq
    gnupg
    just
    jq
    lazygit
    neovim
    nb
    pass
    passExtensions.pass-otp
    pinentry_mac
    ripgrep
    starship
    zoxide
    tree-sitter
    tree
    wget
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    zsh-abbr
  ];
}
