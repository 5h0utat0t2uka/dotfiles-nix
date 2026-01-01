{ pkgs, ... }:

let
  identity = import ../../config/identity.nix;
in {
  home.username = identity.username;
  home.homeDirectory = identity.homeDirectory;
  home.stateVersion = "25.11";

  programs.zsh.enable = true;
  programs.git.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    chezmoi
    git
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
  ];
}
