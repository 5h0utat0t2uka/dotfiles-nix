return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "lua", "vim", "vimdoc", "bash",
      "tsx", "json", "html", "typescript", "javascript"
    },
  },
  config = function(_, opts)
    -- 修正: configs を削除
    require("nvim-treesitter").setup(opts)
  end,
}
