{ ... }:

{
  # XDG base directories を Home Manager 管理
  xdg.enable = true;
  # ~/.zshenv は zsh が最初に読むので ZDOTDIR はここで設定する
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
  # ~/.config/zsh 配下
  xdg.configFile = {
    "zsh/.zprofile".source = ./zprofile;
    "zsh/.zshrc".source = ./zshrc;
    "zsh/.p10k.zsh".source = ./p10k.zsh;
  };
  # $HOME/.local/bin を PATH に追加
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
