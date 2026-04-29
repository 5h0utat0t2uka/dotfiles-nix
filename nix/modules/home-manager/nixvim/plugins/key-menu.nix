{ pkgs, ... }:

let
  key-menu-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "key-menu.nvim";
    version = "unstable-171ad5c";
    src = builtins.fetchGit {
      url = "https://github.com/emmanueltouzery/key-menu.nvim.git";
      rev = "171ad5c40fe978ebba86026beac1ac3ed8eda42d";
    };
  };
in
{
  extraPlugins = [ key-menu-nvim ];

  extraConfigLua = ''
    vim.o.timeoutlen = 300
    require("key-menu").set("n", "<Space>")
    require("key-menu").set("n", "g")
  '';
}
