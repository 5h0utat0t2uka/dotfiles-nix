return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '-' },
          topdelete = { text = '-' },
          changedelete = { text = '~' },
          untracked = { text = '?' },
        },
        signs_staged = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '-' },
          topdelete = { text = '-' },
          changedelete = { text = '~' },
          untracked = { text = '?' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        current_line_blame = true,
        watch_gitdir = {
          follow_files = true,
        },
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        preview_config = {
          border = 'rounded',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
          map('n', '<leader>hi', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })
          vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
            fg = "#4C566A",
            bg = "NONE",
            bold = false,
          })
        end,
      })
    end,
  },
}
