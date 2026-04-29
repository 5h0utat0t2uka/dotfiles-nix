{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ { plugin = lspsaga-nvim; optional = true; } ];
  plugins.lz-n.plugins = [{
    __unkeyed-1 = "lspsaga.nvim";
    event = "LspAttach";
    keys = [
      { __unkeyed-1 = "<Leader>lf"; __unkeyed-2 = "<cmd>Lspsaga finder<CR>"; desc = "LspSaga Finder"; }
      { __unkeyed-1 = "<Leader>ld"; __unkeyed-2 = "<cmd>Lspsaga peek_definition<CR>"; desc = "LspSaga Definition"; }
      { __unkeyed-1 = "<Leader>la"; __unkeyed-2 = "<cmd>Lspsaga code_action<CR>"; desc = "LspSaga Action"; }
    ];
    after = ''
      function()
        require("lspsaga").setup({
          finder = { number = true, relativenumber = false },
          symbol_in_winbar = { enable = false },
          lightbulb = { enable = false, virtual_text = false },
          ui = {
            title = false,
            code_action = "",
            expand = "",
            collapse = "",
            lines = { "└", "├", "│", "", "┌" },
          },
        })
      end
    '';
  }];
}
