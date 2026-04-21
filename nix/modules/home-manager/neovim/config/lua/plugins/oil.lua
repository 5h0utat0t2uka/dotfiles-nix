return {
  {
    "stevearc/oil.nvim",
    enabled = true,
    dependencies = {
      -- { "nvim-mini/mini.icons", opts = {} },
      { "refractalize/oil-git-status.nvim" },
    },
    lazy = false,
    config = function()
      vim.api.nvim_set_hl(0, "OilFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "OilFloatBorder", { link = "Normal" })

      local oil = require("oil")
      oil.setup({
        default_file_explorer = true,
        columns = {
          -- "icon",
          "permissions",
          -- "size",
          "mtime",
        },
        win_options = {
          signcolumn = "yes:2",
          number = false,
          relativenumber = false,
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            return name == "node_modules"
              or name == ".git"
              or name == ".next"
              or name == ".DS_Store"
              or name == "dist"
          end,
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
              or f:match("%.ds_store$") ~= nil
          end,
        },
        confirmation = {
          min_width = { 40, 0.4 },
          max_width = 0.9,
          min_height = { 5, 0.1 },
          max_height = 0.9,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        keymaps = {
          ["q"] = { "actions.close", mode = "n" },
          ["<C-p>"] = { "actions.preview", opts = { split = "belowright" } },
        },
      })

      require("oil-git-status").setup({
        show_ignored = true,
        -- symbols = {
        --   index = {
        --     ["M"] = "M",
        --     ["A"] = "A",
        --     ["D"] = "D",
        --     ["R"] = "R",
        --     ["?"] = "?",
        --     ["!"] = "!",
        --     [" "] = " ",
        --   },
        --   working_tree = {
        --     ["M"] = "M",
        --     ["A"] = "A",
        --     ["D"] = "D",
        --     ["R"] = "R",
        --     ["?"] = "?",
        --     ["!"] = "!",
        --     [" "] = " ",
        --   },
        -- },
      })

      local preview_opts = {
        preview = {
          split = "belowright",
        },
      }
      vim.keymap.set("n", "-", function()
        oil.open(nil, preview_opts)
      end, { desc = "Open parent directory with preview" })
    end,
  },
}
