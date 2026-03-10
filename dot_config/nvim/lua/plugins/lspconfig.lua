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
      -- vim.lsp.config("ts_ls", {
      --   capabilities = capabilities,
      -- })
      -- vim.lsp.enable("ts_ls")

      -- vim.lsp.config("astro", {
      --   capabilities = capabilities,
      -- })
      -- vim.lsp.enable("astro")

      -- vim.lsp.config("eslint", {
      --   capabilities = capabilities,
      -- })
      -- vim.lsp.enable("eslint")
    end,
  },
}
