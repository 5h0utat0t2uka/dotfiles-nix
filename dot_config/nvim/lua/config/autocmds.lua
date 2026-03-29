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
    local matches = vim.fn.getmatches()
    for _, m in ipairs(matches) do
      if m.pattern == "\\%u200b" then
        return
      end
    end
    vim.fn.matchadd("ErrorMsg", "\\%u200b")
  end,
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     local clients = vim.lsp.get_clients({ bufnr = 0 })
--     if #clients > 0 then
--       local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
--       if #diagnostics > 0 then
--         vim.diagnostic.open_float(nil, {
--           focus = false,
--           scope = "cursor",
--           close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--           border = "rounded",
--           source = "if_many",
--         })
--       else
--         vim.lsp.buf.hover()
--       end
--     end
--   end,
-- })

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
