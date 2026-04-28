{ pkgs, identity, ... }:

let
  username = identity.username;
  homeDirectory = identity.homeDirectory;
in

{
  imports = [
    ../../../modules/nix-darwin/system.nix
    ../../../modules/nix-darwin/shell.nix
    ../../../modules/nix-darwin/homebrew.nix
    ../../../modules/nix-darwin/launchd.nix
  ];

  home-manager.users.${username} = {
    imports = [
      ../../../modules/home-manager/ghostty
      ../../../modules/home-manager/wezterm
      ../../../modules/home-manager/tmux
      ../../../modules/home-manager/git
      ../../../modules/home-manager/zsh
      # ../../../modules/home-manager/zed
      ../../../modules/home-manager/neovim
      ../../../modules/home-manager/direnv
      ../../../modules/home-manager/lazygit
      ../../../modules/home-manager/aerospace
      ../../../modules/home-manager/glow
      ../../../modules/home-manager/bat
      ../../../modules/home-manager/lf
      ../../../modules/home-manager/nb
    ];
    manual = {
      # NOTE: issue: problem with home-manager manual
      # https://github.com/nix-community/home-manager/issues/7935
      manpages.enable = false;
    };
    home = {
      stateVersion = "25.11";
      username = username;
      homeDirectory = homeDirectory;
      packages = with pkgs; [
        age
        chafa
        devbox
        eza
        fd
        fzf
        gh
        gifski
        # glow
        gnupg
        just
        jq
        libwebp
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
        nixd
        nil
        lua-language-server
        vscode-langservers-extracted
        copilot-language-server
      ];
    };
  };
}
