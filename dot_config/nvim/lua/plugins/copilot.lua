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
