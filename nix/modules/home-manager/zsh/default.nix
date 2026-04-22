{ pkgs, ... }:

let
  zshPluginDir = "share/zsh/plugins";
  zshPluginLinks = pkgs.linkFarm "zsh-plugin-links" [
    {
      name = "${zshPluginDir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      path = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }
    {
      name = "${zshPluginDir}/zsh-autosuggestions/zsh-autosuggestions.zsh";
      path = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "${zshPluginDir}/zsh-abbr/zsh-abbr.zsh";
      path = "${pkgs.zsh-abbr}/share/zsh/zsh-abbr/zsh-abbr.zsh";
    }
    {
      name = "${zshPluginDir}/powerlevel10k";
      path = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
    }
  ];
in
{
  xdg.enable = true;
  home.file.".zshenv".text = ''
    # XDG Base Directory Specification
    export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
    export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
    export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
    # Zsh Configuration Directory
    export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    # Zsh Sessions Directory
    export SHELL_SESSIONS_DIR="$XDG_CACHE_HOME/zsh/sessions"
    # nb
    export NBRC_PATH="$XDG_CONFIG_HOME/nb/.nbrc"
  '';
  xdg.configFile = {
    "zsh/.zprofile".source = ./zprofile;
    "zsh/.zshrc".source = ./zshrc;
    "zsh/.p10k.zsh".source = ./p10k.zsh;
  };
  # home.sessionPath は nix-darwin の /etc/zshrc 上書きの影響で zsh に反映されないため .zprofile で直接設定する

  # zsh 関連パッケージはこのモジュールで管理
  home.packages = with pkgs; [
    zsh-completions
    zshPluginLinks
  ];
}
