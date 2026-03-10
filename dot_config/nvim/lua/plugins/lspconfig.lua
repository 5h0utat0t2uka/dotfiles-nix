-- lua/plugins/lspconfig.lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("lua_ls")

      vim.lsp.config("nixd", {
        capabilities = capabilities,
      })
      vim.lsp.enable("nixd")

      vim.lsp.config("eslint", {
        capabilities = capabilities,
      })
      if vim.fn.executable("vscode-eslint-language-server") == 1 then
          vim.lsp.enable("eslint")
      end

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })
      if vim.fn.executable("typescript-language-server") == 1 then
        vim.lsp.enable("ts_ls")
      end

      vim.lsp.config("astro", {
        capabilities = capabilities,
      })
      if vim.fn.executable("astro-ls") == 1 then
        vim.lsp.enable("astro")
      end
    end,
  },
}
