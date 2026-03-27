-- ~/.config/nvim/lua/config/autocmds.lua

local english_im = "com.apple.inputmethod.Kotoeri.RomajiTyping.Roman"

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("AutoSwitchIMOnNormal", { clear = true }),
  pattern = "*:n*",
  callback = function()
    vim.fn.system({ "macism", english_im })
  end,
})

vim.o.updatetime = 300
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.fn.matchadd("ErrorMsg", "\\%u200b")
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#2E3440", bg = "#BF616A" })
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#2E3440", bg = "#81A1C1" })
  end,
})
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      scope = "cursor",
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "if_many",
    })
  end,
})
