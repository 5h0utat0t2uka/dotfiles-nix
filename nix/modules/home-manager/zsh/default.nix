{ config, pkgs, lib, ... }:

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
    profileExtra = builtins.readFile ./zprofile;
    envExtra = ''
      export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
      export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
      export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
    '';
    sessionVariables = {
      SHELL_SESSIONS_DIR = "${config.xdg.cacheHome}/zsh/sessions";
      POWERLEVEL9K_INSTANT_PROMPT_DIR = "${config.xdg.cacheHome}/zsh";
      POWERLEVEL9K_DUMP_DIR = "${config.xdg.cacheHome}/zsh";
      # FIX:
      # nixpkgs zsh-powerlevel10k gitstatus issue
      # https://github.com/nixos/nixpkgs/issues/498550?utm_source=chatgpt.com
      POWERLEVEL9K_DISABLE_GITSTATUS = "true";
      ABBR_USER_ABBREVIATIONS_FILE = "${config.xdg.configHome}/zsh-abbr/user-abbreviations";
      ABBR_SET_EXPANSION_CURSOR = "1";
      ABBR_SET_LINE_CURSOR = "1";
      ABBR_EXPANSION_CURSOR_MARKER = "@";
      ABBR_LINE_CURSOR_MARKER = "@";
    };
    history = {
      path = "${config.xdg.cacheHome}/zsh/.zsh_history";
      size = 10000;
      save = 10000;
    };
    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
    };
    syntaxHighlighting = {
      enable = true;
    };
    zsh-abbr = {
      enable = true;
      abbreviations = {
        gs = "git status";
        gd = "git diff";
        ga = "git add .";
        gc = ''git commit -m "@"'';
        gp = "git push origin HEAD";
        gl = "git log --graph --all --decorate --pretty=format:'%C(magenta)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset %s%C(red)%d%Creset' --date=short";
        nri = "ni";
        nrf = "ni --frozen";
        nrd = "nr dev";
        nrb = "nr build";
        nrs = "nr start";
      };
    };
    shellAliases = {
      ".." = "cd ..";
      vpn = "${config.home.homeDirectory}/Development/scripts/vpn/connect.sh";
      webp = "${config.home.homeDirectory}/Development/scripts/webp.sh";
      vim = "nvim";
      ll = "eza -alo --icons --time-style iso";
      lg = "lazygit";
    };
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        [[ $- != *i* ]] && return
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        # FIX:
        # nixpkgs zsh-powerlevel10k gitstatus issue
        # https://github.com/nixos/nixpkgs/issues/498550?utm_source=chatgpt.com
        export POWERLEVEL9K_DISABLE_GITSTATUS=true

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        if [[ -f "$HOME/.config/zsh/.p10k.zsh" ]]; then
          source "$HOME/.config/zsh/.p10k.zsh"
        fi
      ''
      (builtins.readFile ./zshrc)
    ];
  };

  xdg.configFile = {
    "zsh/.p10k.zsh".source = ./p10k.zsh;
  };
  home.packages = with pkgs; [
    zsh-completions
  ];
}
