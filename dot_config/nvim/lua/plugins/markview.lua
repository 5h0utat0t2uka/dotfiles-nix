 return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        filetypes = { "markdown", "mdx", "markdown.mdx" },
        icon_provider = "",
      },
    },
    keys = {
      { "<leader>st", "<cmd>Markview splitToggle<cr>", desc = "Markview split toggle" },
    },
    config = function(_, opts)
      require("markview").setup(opts)
      vim.api.nvim_set_hl(0, "MarkviewCode", {
        -- bg = "#353A49",
        bg = "#3B4252",
      })
      vim.api.nvim_set_hl(0, "MarkviewCodeInfo", {
        -- bg = "#353A49",
        bg = "#3B4252",
      })
    end,
  },
}
