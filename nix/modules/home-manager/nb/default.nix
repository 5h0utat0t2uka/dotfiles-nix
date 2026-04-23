{ config, ... }:

{
  home.sessionVariables.NBRC_PATH = "${config.xdg.configHome}/nb/.nbrc";
  xdg.configFile = {
    "nb/.nbrc".text = ''
      # Managed by Home Manager.
      # Do not edit with `nb set`, `nb unset`, or `nb settings edit`.
      export NB_DIR="${config.home.homeDirectory}/Development/repositories/github.com/5h0utat0t2uka/nb"
      export EDITOR="nvim"
    '';
  };

  # programs.zsh.initContent = lib.mkAfter ''
  #   nb() {
  #     case "$1" in
  #       set|unset)
  #         print -u2 "blocked: nb $1 は .nbrc The settings are managed on Nix Home Manager."
  #         return 1
  #         ;;
  #       settings)
  #         case "$2" in
  #           ""|set|unset|edit)
  #             print -u2 "blocked: nb settings ${2:-<interactive>} は .nbrc The settings are managed on Nix Home Manager."
  #             return 1
  #             ;;
  #         esac
  #         ;;
  #     esac
  #     command nb "$@"
  #   }
  # '';
}