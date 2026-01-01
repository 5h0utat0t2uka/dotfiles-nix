{ pkgs, ... }:
{
  home.stateVersion = "25.11";

  programs.git.enable = true;
  programs.zsh.enable = true;

  # direnv（Nix連携）
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # 必要になったらここへ user-level ツールを追加していく
  home.packages = with pkgs; [
  ];
}
