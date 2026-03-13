return {
  {
    "emmanueltouzery/key-menu.nvim",
    config = function()
      vim.o.timeoutlen = 300
      vim.api.nvim_set_hl(0, "KeyMenuNormal", { fg = "#5E81AC", bg = "#2E3440" })
      vim.api.nvim_set_hl(0, "KeyMenuFloatBorder", { fg = "#4C566A", bg = "#2E3440" })

      require("key-menu").set("n", "<Space>")
      require("key-menu").set("n", "g")
      require("key-menu").set("i", "M")
    end,
  },
}
