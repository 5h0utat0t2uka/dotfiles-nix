{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ toggleterm-nvim ];
  extraConfigLua = ''
    require("toggleterm").setup({
      size = function(term) if term.direction == "horizontal" then return 15 end return 20 end,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_filetypes = {},
      highlights = {},
      autochdir = false,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      clear_env = false,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = { border = "curved", title_pos = "center", winblend = 3 },
      winbar = { enabled = false, name_formatter = function(term) return term.name end },
    })

    vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm direction=float<CR>", { silent = true })
    vim.keymap.set("t", "<C-t>", [[<C-\><C-n><cmd>ToggleTerm direction=float<CR>]], { silent = true })

    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
    function _G._lazygit_toggle() lazygit:toggle() end
    vim.keymap.set("n", "<c-g>", _G._lazygit_toggle, { noremap = true, silent = true })
  '';
}
