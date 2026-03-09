-- ~/.config/nvim/lua/config/autocmds.lua

local english_im = "com.apple.keylayout.ABC"

vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("AutoSwitchIM", { clear = true }),
  callback = function()
    if vim.fn.executable("macism") == 1 then
      vim.fn.system({ "macism", english_im })
    end
  end,
})
