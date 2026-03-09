-- ~/.config/nvim/lua/config/autocmds.lua

local english_im = "com.apple.inputmethod.Kotoeri.RomajiTyping.Roman"

vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("AutoSwitchIM", { clear = true }),
  callback = function()
    vim.fn.system({ "macism", english_im })
  end,
})
