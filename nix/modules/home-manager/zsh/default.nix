{ config, pkgs, lib, ... }:
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

  # - HM が ~/.zshenv(エントリポイント) と $ZDOTDIR/.zshenv を生成。
  # - envExtra: $ZDOTDIR/.zshenv に埋め込まれる。
  # - profileExtra: $ZDOTDIR/.zprofile に埋め込まれる。
  # - initContent: $ZDOTDIR/.zshrc に優先度順に展開される。
  #   - mkBefore (500): p10k instant prompt (HM 自動生成コードより前)
  #   - 通常 (1000): zshrc-body 本体
  # - enableCompletion = false: compinit は zshrc-body 側で管理する方針維持。
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    dotDir = "${config.xdg.configHome}/zsh";
    defaultKeymap = "emacs";
    envExtra = ''
      export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
      export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
      export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
      export SHELL_SESSIONS_DIR="$XDG_CACHE_HOME/zsh/sessions"
      export NBRC_PATH="$XDG_CONFIG_HOME/nb/.nbrc"
    '';

    profileExtra = builtins.readFile ./zprofile;
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        [[ $- != *i* ]] && return
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (builtins.readFile ./zshrc)
      (lib.mkAfter ''
        if [[ -r "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
          source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        fi
      '')
    ];
  };

  xdg.configFile = {
    "zsh/.p10k.zsh".source = ./p10k.zsh;
  };
  home.packages = with pkgs; [
    zsh-completions
    zshPluginLinks
  ];
}
