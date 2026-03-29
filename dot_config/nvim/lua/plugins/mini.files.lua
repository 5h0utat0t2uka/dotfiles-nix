return {
  "nvim-mini/mini.files",
  enabled = false,
  version = "*",
  config = function()
    require("mini.files").setup({
      windows = {
        preview = true,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 50,
      },
      options = {
        use_as_default_explorer = true,
      },
    })

    vim.keymap.set("n", "<leader>mf", function()
      require("mini.files").open()
    end, { desc = "Open mini.files" })
  end,
}
