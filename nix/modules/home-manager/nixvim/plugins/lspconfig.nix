{ pkgs, ... }:

{
  plugins.lazydev = {
    enable = true;
    lazyLoad.settings = {
      ft = "lua";
    };
    settings = { };
  };
  plugins.lsp = {
    enable = true;
    autoLoad = true;
  };
  extraConfigLua = ''
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              vim.env.VIMRUNTIME .. "/lua",
            },
          },
          diagnostics = {
            globals = { "vim" },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })
    vim.lsp.config("nixd", {
      settings = {
        nixd = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    })
    vim.lsp.config("ts_ls", {
      root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, {
          "tsconfig.json",
          "jsconfig.json",
          "package.json",
          ".git",
        })
        if root then
          on_dir(root)
          return
        end
        local name = vim.api.nvim_buf_get_name(bufnr)
        local dir = vim.fs.dirname(name)
        if dir and dir ~= "" then
          on_dir(dir)
        end
      end,
    })
    vim.lsp.config("astro", {
      before_init = function(_, config)
        config.init_options = config.init_options or {}
        config.init_options.typescript = config.init_options.typescript or {}
        if config.init_options.typescript.tsdk then
          return
        end
        local root = config.root_dir or vim.fs.root(0, {
          "package.json",
          "tsconfig.json",
          "jsconfig.json",
          ".git",
        })
        local candidates = {}
        if root then
          table.insert(candidates, root .. "/node_modules/typescript/lib")
        end
        table.insert(candidates, "${pkgs.typescript}/lib/node_modules/typescript/lib")
        for _, tsdk in ipairs(candidates) do
          if vim.uv.fs_stat(tsdk .. "/typescript.js")
            or vim.uv.fs_stat(tsdk .. "/tsserverlibrary.js") then
            config.init_options.typescript.tsdk = tsdk
            return
          end
        end
      end,
    })

    vim.lsp.config("eslint", {})
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("nixd")
    vim.lsp.enable("eslint")
    vim.lsp.enable("ts_ls")
    vim.lsp.enable("astro")
    vim.lsp.enable("html")
    vim.lsp.enable("cssls")
    pcall(vim.lsp.enable, "copilot")
    vim.lsp.inline_completion.enable(true)
    vim.keymap.set("i", "<M-CR>", function()
      vim.lsp.inline_completion.get()
    end, { silent = true, desc = "Copilot inline completion" })
  '';
}
