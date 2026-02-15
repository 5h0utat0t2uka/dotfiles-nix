return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,  -- lazy-loadingはサポートされていない
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    require("nvim-treesitter").install({
      "lua", "vim", "vimdoc", "bash",
      "typescript", "tsx", "json", "html", "javascript"
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json", "typescript", "javascript", "tsx", "html" },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
