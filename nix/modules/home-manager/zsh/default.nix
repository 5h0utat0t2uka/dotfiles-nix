{ ... }:

{
  home.file.".zshenv".source = ./zshenv;

  # ~/.config/zsh 配下は xdg.configFile で配置する。
  xdg.configFile = {
    "zsh/.zprofile".source = ./zprofile;
    "zsh/.zshrc".source = ./zshrc;
    "zsh/.p10k.zsh".source = ./p10k.zsh;
  };
}