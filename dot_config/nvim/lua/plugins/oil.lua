return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
    },
    lazy = false,
    config = function()
      vim.api.nvim_set_hl(0, "OilFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "OilFloatBorder", { link = "Normal" })
      -- vim.api.nvim_set_hl(0, "OilPreviewSeparator", { fg = "#4C566A" })

      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon" },
        view_options = {
          show_hidden = false,
        },
        float = {
          padding = 6,
          max_width = 0.8,
          max_height = 0.8,
          border = "single",
          win_options = {
            winblend = 0,
            winhighlight = "NormalFloat:OilFloat,FloatBorder:OilFloatBorder",
          },
        },
        preview_win = {
          update_on_cursor_moved = true,
          preview_method = "fast_scratch",
          -- win_options = {
          --   winhighlight = "WinSeparator:OilPreviewSeparator",
          -- },
        },
        keymaps = {
          ["q"] = { "actions.close", mode = "n" },
          ['<C-p>'] = { 'actions.preview', opts = { split = 'belowright' } },
        },
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil" })
      vim.keymap.set("n", "<leader>E", "<CMD>Oil --float<CR>", { desc = "Open Oil float" })
    end,
  },
}
