# modules/home-manager/neovim/default.nix
{ config, pkgs, ... }:

# {
#   home.packages = with pkgs; [
#     neovim
#   ];
#   xdg.configFile."nvim".source =
#     config.lib.file.mkOutOfStoreSymlink
#       "${config.home.homeDirectory}/.local/share/chezmoi/nix/modules/home-manager/neovim/config";
# }

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    initLua = builtins.readFile ./config/init.lua;
    extraPackages = with pkgs; [
      lua-language-server
      nixd
      nil
      vscode-langservers-extracted
      copilot-language-server
    ];
  };

  xdg.configFile = {
    "nvim/lua" = {
      source = ./config/lua;
      recursive = true;
    };
    "nvim/after" = {
      source = ./config/after;
      recursive = true;
    };
    "nvim/snippets" = {
      source = ./config/snippets;
      recursive = true;
    };
    "nvim/.luarc.json".source = ./config/.luarc.json;

    # lazy-lock.json は書き込み可能にする
    "nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/.local/share/chezmoi/nix/modules/home-manager/neovim/config/lazy-lock.json";
  };
}
