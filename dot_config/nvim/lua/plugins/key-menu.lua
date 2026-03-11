return {
  {
    "emmanueltouzery/key-menu.nvim",
    config = function()
      vim.o.timeoutlen = 300

      require("key-menu").set("n", "<Space>")
      require("key-menu").set("n", "g")
      require("key-menu").set("i", "M")
    end,
  },
}
