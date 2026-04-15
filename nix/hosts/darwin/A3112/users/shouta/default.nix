{ pkgs, lib, identity, inputs, ... }:

let
  zshPluginLinks = pkgs.linkFarm "zsh-plugin-links" [
    {
      name = "share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      path = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }
    {
      name = "share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh";
      path = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "share/zsh/plugins/zsh-abbr/zsh-abbr.zsh";
      path = "${pkgs.zsh-abbr}/share/zsh/zsh-abbr/zsh-abbr.zsh";
    }
    {
      name = "share/zsh/plugins/powerlevel10k";
      path = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
    }
    # {
    #   name = "share/zsh/plugins/zeno.zsh/zeno.zsh";
    #   path = "${pkgs.zeno-zsh}/share/zeno.zsh/zeno.zsh";
    # }
    # {
    #   name = "share/zsh/plugins/zeno.zsh/zeno-bootstrap.zsh";
    #   path = "${pkgs.zeno-zsh}/share/zeno.zsh/zeno-bootstrap.zsh";
    # }
  ];
in
{
  # Issue: https://github.com/nix-community/home-manager/issues/7935
  manual = {
    manpages.enable = false;
  };

  # ドットファイルの実体は chezmoi で管理する前提なので
  # home-manager では生成しない
  programs = {
    zsh.enable = false;
    git.enable = false;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
    };
  };

  home = {
    stateVersion = "25.11";
    username = identity.username;
    homeDirectory = identity.homeDirectory;

    packages = with pkgs; [
      age
      bat
      chafa
      # claude-code
      copilot-language-server
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
      # pkgs.keifu
      libwebp
      lf
      lazygit
      lua-language-server
      macism
      mise
      neovim
      nb
      ni
      nixd
      nil
      nmap
      nodejs_24
      pnpm
      (pass.withExtensions (exts: [
        exts.pass-otp
      ]))
      pinentry_mac
      ripgrep
      # termscp
      # tree-sitter
      pkgs."tree-sitter-0267"
      tree
      tmux
      # uv
      viu
      vscode-langservers-extracted
      wget
      zbar
      zoxide
      # zeno-zsh
      zsh-syntax-highlighting
      zsh-autosuggestions
      zsh-completions
      zsh-abbr
      zsh-powerlevel10k
      zshPluginLinks
    ];

    activation.ensureNbConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/nb"
      if [ ! -e "$HOME/.config/nb/.nbrc" ]; then
        : > "$HOME/.config/nb/.nbrc"
      fi
    '';
  };
}
