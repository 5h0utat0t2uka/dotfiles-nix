# modules/home-manager/tmux/default.nix
{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  xdg.configFile = {
    "tmux/bin/pane-cwd-label.sh" = {
      source = ./bin/pane-cwd-label.sh;
      executable = true;
    };
    "tmux/bin/pane-git-branch.sh" = {
      source = ./bin/pane-git-branch.sh;
      executable = true;
    };
  };
}
