return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        use_treesitter = false,
        style = {
          { fg = "#4C566A" },
          { fg = "#D08770" },
        },
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "┌",
          left_bottom = "└",
          right_arrow = "─",
        },
      },
      indent = {
        enable = true,
        chars = { "│" },
        style = { { fg = "#3B4252" } },
      },
    })
  end
}
