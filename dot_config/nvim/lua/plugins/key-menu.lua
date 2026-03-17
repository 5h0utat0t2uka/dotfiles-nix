return {
  {
    "emmanueltouzery/key-menu.nvim",
    enabled = true,
    config = function()
      vim.o.timeoutlen = 300
      vim.api.nvim_set_hl(0, "KeyMenuNormal", { fg = "#2E3440", bg = "#4C566A" })
      vim.api.nvim_set_hl(0, "KeyMenuFloatBorder", { fg = "#4C566A", bg = "#4C566A" })

      require("key-menu").set("n", "<Space>")
      require("key-menu").set("n", "g")
      require("key-menu").set("i", "M")
    end,
  },
}
