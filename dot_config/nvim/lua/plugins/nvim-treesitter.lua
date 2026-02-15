return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup()
    treesitter.install({
      "lua", "vim", "vimdoc", "query",
      "typescript", "tsx", "json", "javascript", "html"
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "vim", "typescript", "tsx",
        "json", "javascript", "html"
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}
