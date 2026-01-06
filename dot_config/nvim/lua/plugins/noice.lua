-- lua/plugins/noice.lua
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },

    opts = {
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
          size = { width = 60, height = "auto" },
          border = {
            style = "rounded",
            padding = { 1, 1 },
          },
        },
      },

      routes = {
        { view = "split", filter = { event = "msg_show", min_height = 10 } },
        { view = "split", filter = { event = "msg_show", min_length = 200 } },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      -- 任意
    },
  },
}
