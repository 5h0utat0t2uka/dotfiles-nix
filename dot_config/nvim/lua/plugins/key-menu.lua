return {
  {
    "emmanueltouzery/key-menu.nvim",
    config = function()
      vim.o.timeoutlen = 300
      vim.api.nvim_set_hl(0, "KeyMenuNormal", { fg = "#D8DEE9", bg = "#4C566A" })
      vim.api.nvim_set_hl(0, "KeyMenuFloatBorder", { fg = "#D8DEE9", bg = "#4C566A" })

      require("key-menu").set("n", "<Space>")
      require("key-menu").set("n", "g")
      require("key-menu").set("i", "M")
    end,
  },
}
