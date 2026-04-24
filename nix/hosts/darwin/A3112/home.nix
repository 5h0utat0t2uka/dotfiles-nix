{ pkgs, identity, ... }:

{
  # Issue: https://github.com/nix-community/home-manager/issues/7935
  manual = {
    manpages.enable = false;
  };

  # 一部を除いてドットファイルの実体は chezmoi で管理する前提なので
  # home-manager では生成しない
  programs = {
    # zsh, git は modules/home-manager/ 配下で Nix 管理
    # zsh.enable = false;
    # git.enable = false;
    # direnv = {
    #   enable = true;
    #   nix-direnv.enable = true;
    # };
  };

  imports = [
    ../../../modules/home-manager/ghostty
    ../../../modules/home-manager/wezterm
    ../../../modules/home-manager/tmux
    ../../../modules/home-manager/git
    ../../../modules/home-manager/zsh
    ../../../modules/home-manager/zed
    ../../../modules/home-manager/direnv
    ../../../modules/home-manager/neovim
    ../../../modules/home-manager/aerospace
    ../../../modules/home-manager/bat
    ../../../modules/home-manager/lf
    ../../../modules/home-manager/nb
  ];

  home = {
    stateVersion = "25.11";
    username = identity.username;
    homeDirectory = identity.homeDirectory;
    packages = with pkgs; [
      age
      chafa
      # delta
      devbox
      eza
      fd
      fzf
      # git
      gh
      # ghq
      gifski
      glow
      gnupg
      just
      jq
      libwebp
      lazygit
      macism
      mise
      ni
      nmap
      nodejs_24
      pnpm
      (pass.withExtensions (exts: [
        exts.pass-otp
      ]))
      pinentry_mac
      ripgrep
      pkgs."tree-sitter-0267"
      tree
      viu
      wget
      zbar
      zoxide
      # LSP
      nixd
      nil
      lua-language-server
      vscode-langservers-extracted
      copilot-language-server
    ];
  };
}
