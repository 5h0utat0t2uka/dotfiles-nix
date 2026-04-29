
# nix/modules/home-manager/nixvim/default.nix
{ pkgs, inputs, ... }:

# 移行前
let
  nixvimPkg = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
    defaultEditor = false;
    withPython3 = false;
    withRuby = false;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts = {
      termguicolors = true;
      ttimeoutlen = 50;
      clipboard = "unnamedplus";
      winborder = "rounded";
      pumborder = "rounded";
      pumblend = 10;
      winblend = 10;
      showcmd = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      whichwrap = "b,s,h,l,<,>,[,],";
      wrap = true;
      linebreak = true;
      expandtab = true;
      showtabline = 1;
      scrolloff = 5;
      breakindent = true;
      number = true;
      relativenumber = false;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      showmatch = true;
      cursorline = true;
      cmdheight = 1;
    };
    colorschemes = {
      nord.enable = true;
    };
    keymaps = [];
    plugins = {
      lualine = {
        enable = true;
      };
    };
    luaLoader = {
      enable = true;
    };
    performance = {
      byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
    };
  };
  nixvimCmd = pkgs.writeShellScriptBin "nixvim" ''
    export NVIM_APPNAME=nixvim
    exec ${nixvimPkg}/bin/nvim "$@"
  '';
in
{
  home.packages = [
    nixvimCmd
  ];
}

# 移行後
# imports = [
#   inputs.nixvim.homeModules.nixvim
# ];
# {
#   programs.nixvim = {
#     enable = true;
#     defaultEditor = true;
#     viAlias = true;
#     vimAlias = true;
#     colorschemes.nord.enable = true;
#     opts = {
#       number = true;
#       relativenumber = true;
#     };
#     globals = {
#       mapleader = " ";
#     };
#     plugins.lualine.enable = true;
#   };
# }
