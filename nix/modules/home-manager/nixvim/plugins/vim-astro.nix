{ pkgs, ... }:

{
  # extraPlugins = [{
  #   plugin = pkgs.vimPlugins.vim-astro;
  #   optional = true;
  # }];
  # plugins.lz-n.plugins = [{
  #   __unkeyed-1 = "vim-astro";
  #   ft = "astro";
  #   after = ''
  #     function()
  #       vim.g.astro_typescript = "enable"
  #     end
  #   '';
  # }];

  extraPlugins = with pkgs.vimPlugins; [
    vim-astro
  ];
  extraConfigLua = ''
    vim.g.astro_typescript = "enable"
  '';
}
