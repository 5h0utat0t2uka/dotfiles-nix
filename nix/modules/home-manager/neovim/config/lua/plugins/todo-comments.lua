return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TodoTelescope",
    "TodoTrouble",
    "TodoQuickFix",
    "TodoLocList",
  },
  keys = {
    {
      "<leader>ft",
      function()
        vim.cmd("TodoTelescope initial_mode=normal")
      end,
      mode = "n",
      desc = "Todo Telescope",
    },
  },
  opts = {
    signs = false,
    keywords = {
      FIX = { icon = "", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = "", color = "info" },
      HACK = { icon = "", color = "warning" },
      WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = "", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = "", color = "hint", alt = { "INFO" } },
      TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#BF616A" },
      warning = { "DiagnosticWarn", "WarningMsg", "#D08770" },
      info = { "DiagnosticInfo", "#A3BE8C" },
      hint = { "DiagnosticHint", "#81A1C1" },
      default = { "Identifier", "#EBCB8B" },
      test = { "Identifier", "#D08770" }
    },
  },
}
