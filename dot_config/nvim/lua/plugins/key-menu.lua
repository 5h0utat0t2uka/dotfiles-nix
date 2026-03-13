return {
  {
    "emmanueltouzery/key-menu.nvim",
    config = function()
      vim.o.timeoutlen = 300
      vim.api.nvim_set_hl(0, "KeyMenuNormal", { link = "Normal" })
      vim.api.nvim_set_hl(0, "KeyMenuFloatBorder", { link = "FloatBorder" })

      require("key-menu").set("n", "<Space>")
      require("key-menu").set("n", "g")
      require("key-menu").set("i", "M")
    end,
  },
}
