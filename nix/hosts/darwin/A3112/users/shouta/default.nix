{ pkgs, lib, identity, ... }:

{
  # Issue: https://github.com/nix-community/home-manager/issues/7935
  manual = {
    manpages.enable = false;
  };

  # 一部を除いてドットファイルの実体は chezmoi で管理する前提なので
  # home-manager では生成しない
  programs = {
    # zsh は modules/home-manager/ 配下で Nix 管理
    # zsh.enable = false;
    git.enable = false;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  imports = [
    ../../../../../modules/home-manager/ghostty
    ../../../../../modules/home-manager/wezterm
    ../../../../../modules/home-manager/tmux
    ../../../../../modules/home-manager/zsh
    ../../../../../modules/home-manager/zed
    ../../../../../modules/home-manager/neovim
  ];

  home = {
    stateVersion = "25.11";
    username = identity.username;
    homeDirectory = identity.homeDirectory;
    packages = with pkgs; [
      age
      bat
      chafa
      delta
      devbox
      eza
      fd
      fzf
      git
      gh
      ghq
      gifski
      glow
      gnupg
      just
      jq
      libwebp
      lf
      lazygit
      macism
      mise
      nb
      ni
      nmap
      nodejs_24
      pnpm
      (pass.withExtensions (exts: [
        exts.pass-otp
      ]))
      pinentry_mac
      ripgrep
      # termscp
      pkgs."tree-sitter-0267"
      tree
      # uv
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

    activation.ensureNbConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/nb"
      if [ ! -e "$HOME/.config/nb/.nbrc" ]; then
        : > "$HOME/.config/nb/.nbrc"
      fi
    '';
  };
}
