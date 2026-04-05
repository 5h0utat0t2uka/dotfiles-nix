return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nixd")
      vim.lsp.enable("eslint")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("astro")
      vim.lsp.enable("copilot")

      vim.lsp.inline_completion.enable(true)
      vim.keymap.set("i", "<M-CR>", function()
        vim.lsp.inline_completion.get()
      end, { silent = true, desc = "Copilot inline completion" })
    end,
  },
}
