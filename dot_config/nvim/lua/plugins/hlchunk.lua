return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        style = {
          { fg = "#81A1C1" },
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
