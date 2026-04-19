# modules/home-manager/neovim/default.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
  ];
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.local/share/chezmoi/nix/modules/home-manager/neovim/config";
}
