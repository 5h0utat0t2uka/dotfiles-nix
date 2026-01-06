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
      -- 既存設定
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },

      -- 追加：大量メッセージで破綻しない設定（最新版の方向性）
      -- 1) notify の増殖を抑える（置換/マージ）
      views = {
        notify = {
          replace = true,
          merge = true,
        },
      },

      -- 2) “重い/長い”メッセージは notify ではなく split に逃がす
      routes = {
        -- 多行は split（通知が詰まるのを防ぐ）
        {
          view = "split",
          filter = { event = "msg_show", min_height = 10 },
        },
        -- 長文も split
        {
          view = "split",
          filter = { event = "msg_show", min_length = 200 },
        },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      -- 任意：通知が溜まりにくい方向に寄せるならここも調整可
      -- timeout = 3000,
      -- max_height = function() return math.floor(vim.o.lines * 0.75) end,
      -- max_width  = function() return math.floor(vim.o.columns * 0.75) end,
    },
  },
}
