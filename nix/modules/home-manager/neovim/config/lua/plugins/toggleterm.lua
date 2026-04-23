return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup{
      -- open_mapping = [[<leader>tt]],
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        end
        return 20
      end,
      open_mapping = [[<c-t>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      highlights = {},
      autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = false, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = true,
      persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
      direction = 'float',
      close_on_exit = true, -- close the terminal window when the process exits
      clear_env = false, -- use only environmental variables from `env`, passed to jobstart()
      shell = vim.o.shell,
      auto_scroll = true, -- automatically scroll to the bottom on terminal output
      float_opts = {
        border = 'curved',
        title_pos = 'center',
        winblend = 3,
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end
      },
    }
    -- float terminal（既存の <C-t>）
    vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm direction=float<CR>", { silent = true })
    vim.keymap.set("t", "<C-t>", [[<C-\><C-n><cmd>ToggleTerm direction=float<CR>]], { silent = true })
    local Terminal  = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
    function _lazygit_toggle()
      lazygit:toggle()
    end
    vim.api.nvim_set_keymap("n", "<c-g>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
  end
}
