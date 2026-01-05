# nix-config/darwin/home.nix
{ pkgs, lib, identity, ... }:

# let
#   zshPluginLinks = pkgs.stdenvNoCC.mkDerivation {
#     name = "zsh-plugin-links";
#     dontUnpack = true;
#     installPhase = ''
#       mkdir -p "$out/share/zsh/plugins"

#       mkdir -p "$out/share/zsh/plugins/zsh-syntax-highlighting"
#       ln -sf \
#         ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
#         "$out/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#       mkdir -p "$out/share/zsh/plugins/zsh-autosuggestions"
#       ln -sf \
#         ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
#         "$out/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

#       mkdir -p "$out/share/zsh/plugins/zsh-abbr"
#       ln -sf \
#         ${pkgs.zsh-abbr}/share/zsh/zsh-abbr/zsh-abbr.zsh \
#         "$out/share/zsh/plugins/zsh-abbr/zsh-abbr.zsh"

#       ln -sfn \
#         ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k \
#         "$out/share/zsh/plugins/powerlevel10k"
#     '';
#   };
# in

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
  home.username = identity.username;
  home.homeDirectory = identity.homeDirectory;

  # HM の互換性基準（固定）
  home.stateVersion = "25.11";

  # Issue (https://github.com/nix-community/home-manager/issues/7935)
  manual.manpages.enable = false;

  # 重要: dotfile の実体は chezmoi が管理する前提なので HM では生成しない
  programs.zsh.enable = false;
  programs.git.enable = false;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
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
    pass
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
  home.activation.ensureNbConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/nb"
    if [ ! -e "$HOME/.config/nb/.nbrc" ]; then
      : > "$HOME/.config/nb/.nbrc"
    fi
  '';
}
