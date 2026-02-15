-- return {
--   "shellRaining/hlchunk.nvim",
--   event = { "BufReadPre", "BufNewFile" },
--   config = function()
--     require("hlchunk").setup({
--       chunk = {
--         enable = true,
--         style = {
--           { fg = "#81A1C1" },
--           { fg = "#D08770" },
--         },
--         chars = {
--           horizontal_line = "─",
--           vertical_line = "│",
--           left_top = "┌",
--           left_bottom = "└",
--           right_arrow = "─",
--         },
--       },
--       indent = {
--         enable = true,
--         chars = { "│" },
--         style = { { fg = "#3B4252" } },
--       },
--     })
--   end
-- }
return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- chunk を個別に設定
    local chunk_mod = require("hlchunk.mods.chunk")
    chunk_mod({
      enable = true,
      use_treesitter = true,
      chars = {
        horizontal_line = "─",
        vertical_line = "│",
        left_top = "┌",
        left_bottom = "└",
        right_arrow = "─",
      },
      style = {
        { fg = "#81A1C1" },
      },
    }):enable()  -- ← :enable() を明示的に呼び出す
    -- indent を個別に設定
    local indent_mod = require("hlchunk.mods.indent")
    indent_mod({
      enable = true,
      chars = { "│" },
      style = {
        { fg = "#3B4252" },
      },
    }):enable()  -- ← :enable() を明示的に呼び出す
  end
}
