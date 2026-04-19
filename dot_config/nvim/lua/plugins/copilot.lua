-- return {
--   "zbirenbaum/copilot.lua",
--   cmd = "Copilot",
--   build = ":Copilot auth",
--   event = "BufReadPost",
--   config = function()
--   require("copilot").setup({
--     suggestion = {
--       auto_trigger = true,
--       keymap = {
--         accept = "<Tab>",
--       },
--     },
--   })
--   end,
-- }

return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  cmd = "Copilot",
  event = "BufReadPost",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
  },
}
