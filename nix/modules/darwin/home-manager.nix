{ pkgs, lib, identity, ... }:

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
  ];
in
{

  # Issue (https://github.com/nix-community/home-manager/issues/7935)
  manual = {
    manpages.enable = false;
  };

  # 重要: dotfile の実体は chezmoi が管理する前提なので HM では生成しない
  programs = {
    zsh.enable = false;
    git.enable = false;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home = {
    stateVersion = "25.11";
    username = identity.username;
    homeDirectory = identity.homeDirectory;
    packages = with pkgs; [
      nixd
      nil
      # affinity
      bat
      chezmoi # 初回curl経由で入れるので消す予定
      delta
      eza
      fd
      fzf
      git
      gh
      ghq
      gnupg
      just
      jq
      lazygit
      neovim
      nb
      ni
      nodejs_24
      onefetch
      pnpm
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      # pass
      passExtensions.pass-otp
      pinentry_mac
      ripgrep
      zoxide
      tree-sitter
      tree
      tmux
      uv
      wget
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
