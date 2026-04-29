{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ key-menu-nvim ];
  extraConfigLua = ''
    vim.o.timeoutlen = 300
    require("key-menu").set("n", "<Space>")
    require("key-menu").set("n", "g")
  '';
}
