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
      local oil = require("oil")
      oil.setup({
        default_file_explorer = true,
        columns = {
          "icon",
          "permissions",
          -- "size",
          -- "mtime",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            return name == "node_modules"
              or name == ".git"
              or name == ".next"
              or name == "dist"
          end,
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
          disable_preview = function(filename)
          local f = filename:lower()
          return f:match("%.png$") ~= nil
            or f:match("%.jpe?g$") ~= nil
            or f:match("%.webp$") ~= nil
            or f:match("%.gif$") ~= nil
            or f:match("%.avif$") ~= nil
            or f:match("%.svg$") ~= nil
            or f:match("%.bmp$") ~= nil
            or f:match("%.ico$") ~= nil
          end,
          -- win_options = {
          --   winhighlight = "WinSeparator:OilPreviewSeparator",
          -- },
        },
        keymaps = {
          ["q"] = { "actions.close", mode = "n" },
          ['<C-p>'] = { 'actions.preview', opts = { split = 'belowright' } },
        },
      })

      -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      -- vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Oil" })
      -- vim.keymap.set("n", "<leader>E", "<CMD>Oil --float<CR>", { desc = "Open Oil float" })
      local preview_opts = {
        preview = {
          split = "belowright",
        },
      }
      vim.keymap.set("n", "-", function()
        oil.open(nil, preview_opts)
      end, { desc = "Open parent directory with preview" })

      vim.keymap.set("n", "<leader>e", function()
        oil.open(nil, preview_opts)
      end, { desc = "Open Oil with preview" })

      vim.keymap.set("n", "<leader>E", function()
        oil.open_float(nil, preview_opts)
      end, { desc = "Open Oil float with preview" })
    end,
  },
}
