{ pkgs, ... }:
{
  globals.astro_typescript = "enable";
  extraPlugins = with pkgs.vimPlugins; [ { plugin = vim-astro; optional = true; } ];
  plugins.lz-n.plugins = [{ __unkeyed-1 = "vim-astro"; ft = "astro"; }];
}
