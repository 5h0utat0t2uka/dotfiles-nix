{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ nb ];
  home.sessionVariables = {
    NBRC_PATH = "${config.xdg.configHome}/nb/.nbrc";
  };

  xdg.configFile."nb/.nbrc".text = ''
    # The settings are managed on Nix Home Manager.
    # Do not edit with `nb set`, `nb unset`, or `nb settings edit`.
    export NB_DIR="${config.home.homeDirectory}/.nb"
    export EDITOR="nvim"
  '';
}
