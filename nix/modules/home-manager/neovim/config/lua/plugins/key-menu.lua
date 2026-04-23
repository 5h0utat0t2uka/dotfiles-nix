return {
  {
    "emmanueltouzery/key-menu.nvim",
    enabled = true,
    config = function()
      vim.o.timeoutlen = 300
      require("key-menu").set("n", "<Space>")
      require("key-menu").set("n", "g")
    end,
  },
}
