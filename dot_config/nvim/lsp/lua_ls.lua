return {
  settings = {
    Lua = {
      workspace = {
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
}
