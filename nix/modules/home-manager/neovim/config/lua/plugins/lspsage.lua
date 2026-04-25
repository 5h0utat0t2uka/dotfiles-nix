return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    finder = {
      number = true,
      relativenumber = false,
    },
    symbol_in_winbar = {
      enable = false,
    },
    lightbulb = {
      enable = false,
      virtual_text = false,
    },
    ui = {
      title = false,
      code_action = '',
      expand = "",
      collapse = "",
      lines = { "└", "├", "│", "", "┌" },
    },
  },
  keys = {
    { "<Leader>lf", "<cmd>Lspsaga finder<CR>", desc = "LspSaga Finder" },
    { "<Leader>ld", "<cmd>Lspsaga peek_definition<CR>", desc = "LspSaga Definition" },
    { "<Leader>la", "<cmd>Lspsaga code_action<CR>", desc = "LspSaga Action" },
  },
}
