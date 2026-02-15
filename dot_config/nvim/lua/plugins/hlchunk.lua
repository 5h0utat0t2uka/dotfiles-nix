return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        use_treesitter = true,
        style = {
          { fg = "#81A1C1" },
          { fg = "#bf616a" },
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
        style = { { fg = "#434C5E" } },
      },
    })

    vim.schedule(function()
      require("hlchunk").enable()
    end)
  end
}
