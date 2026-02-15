return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash",
        "typescript", "tsx", "json", "html", "javascript"
      },
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json", "typescript", "javascript", "tsx", "html" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
