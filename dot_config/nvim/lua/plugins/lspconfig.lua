return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      if vim.fn.executable("lua-language-server") == 1 then
        vim.lsp.enable("lua_ls")
      end

      if vim.fn.executable("nixd") == 1 then
        vim.lsp.enable("nixd")
      end

      if vim.fn.executable("vscode-eslint-language-server") == 1 then
        vim.lsp.enable("eslint")
      end

      if vim.fn.executable("typescript-language-server") == 1 then
        vim.lsp.enable("ts_ls")
      end

      if vim.fn.executable("astro-ls") == 1 then
        vim.lsp.enable("astro")
      end
    end,
  },
}
