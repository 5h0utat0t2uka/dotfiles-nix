return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.config("copilot", {
        on_attach = function(client)
          client.request("github.copilot.checkStatus", {}, function(_, result)
            if not result or not result.user then
              client.request("github.copilot.signIn", {})
            end
          end)
        end,
      })
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nixd")
      vim.lsp.enable("eslint")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("astro")
      vim.lsp.enable("copilot")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")

      vim.lsp.inline_completion.enable(true)
      vim.keymap.set("i", "<M-CR>", function()
        vim.lsp.inline_completion.get()
      end, { silent = true, desc = "Copilot inline completion" })
    end,
  },
}
