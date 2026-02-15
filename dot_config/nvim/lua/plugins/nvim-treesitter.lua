return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash",
        "tsx", "json", "html", "typescript", "javascript"
      },
      auto_install = true
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json", "typescript", "javascript", "tsx" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
