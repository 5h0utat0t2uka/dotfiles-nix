-- lua/plugins/noice.lua
return {
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },

    opts = {
      cmdline = {
        format = {
          cmdline = { title = "", pattern = "^:", icon = "", lang = "vim" },
          input = { title = "", icon = "", view = "cmdline_input" },
          search_down = { title = "", kind = "search", pattern = "^/", icon = "", lang = "regex" },
          search_up = { title = "", kind = "search", pattern = "^%?", icon = "", lang = "regex" },
          filter = { title = "", pattern = "^:%s*!", icon = "", lang = "bash" },
          lua = { title = "", pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
          help = { title = "", pattern = "^:%s*he?l?p?%s+", icon = "" },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        -- bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },

      views = {
        notify = {
          replace = true,
          merge = true,
        },

        cmdline_popup = {
          position = { row = "50%", col = "50%" },
          size = { min_width = 60, width = "auto", height = "auto" },
          border = {
            style = "rounded",
            padding = { 1, 1 },
          },
          win_options = {
            winblend = 10,        -- 0（不透明）〜 100（完全透明）
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        -- confirm = {
        --   position = { row = "50%", col = "50%" },
        --   size = { width = 60, height = "auto" },
        --   border = {
        --     style = "rounded",
        --     padding = { 2, 2 },
        --   },
        --   win_options = {
        --     winblend = 10,
        --     winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        --   },
        -- },
      },

      routes = {
        { view = "split", filter = { event = "msg_show", min_height = 10 } },
        { view = "split", filter = { event = "msg_show", min_length = 200 } },
        -- {
        --   view = "confirm",
        --   filter = { event = "msg_show", kind = "confirm_sub" },
        -- },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      stages = "static",
      timeout = 3000,
    },
  },
}
