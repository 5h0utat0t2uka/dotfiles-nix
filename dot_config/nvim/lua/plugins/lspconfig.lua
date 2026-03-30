return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("astro", {
        before_init = function(_, config)
          if not (config.init_options and config.init_options.typescript) then
            return
          end
          if config.init_options.typescript.tsdk and config.init_options.typescript.tsdk ~= "" then
            return
          end
          local tsc = vim.fn.trim(vim.fn.system("which tsc"))
          if tsc ~= "" then
            local nix_tsdk = vim.fn.trim(vim.fn.system("dirname $(dirname " .. tsc .. ")")) .. "/lib/node_modules/typescript/lib"
            if vim.uv.fs_stat(nix_tsdk) then
              config.init_options.typescript.tsdk = nix_tsdk
            end
          end
        end,
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nixd")
      vim.lsp.enable("eslint")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("astro")
    end,
  },
}
