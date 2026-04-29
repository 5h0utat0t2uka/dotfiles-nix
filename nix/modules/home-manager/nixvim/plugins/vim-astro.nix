{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    vim-astro
  ];

  extraConfigLua = ''
    vim.g.astro_typescript = "enable"
  '';
}
