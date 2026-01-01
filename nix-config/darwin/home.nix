# nix-config/darwin/home.nix
{ pkgs, identity, ... }:

{
  home.username = identity.username;
  home.homeDirectory = identity.homeDirectory;
  home.stateVersion = "25.11";

  programs.zsh.enable = false;
  programs.git.enable = false;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    chezmoi
    gnupg
    git
    ghq
    gh
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
    pass
    passExtensions.pass-otp
    pinentry_mac
  ];
}
