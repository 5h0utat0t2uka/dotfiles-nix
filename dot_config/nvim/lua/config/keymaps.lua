-- normal mode keymaps
vim.keymap.set("n", "gk", "<Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "gh", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "gl", "<Cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "gj", "<Cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "gJ", "<Cmd>tabclose!<CR>", { desc = "Force close tab" })
vim.keymap.set("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohlsearch()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
      "n",
      false
    )
  end
end, { desc = "Clear search highlight or escape" })

-- insert mode keymaps
vim.keymap.set('i', '<M-w>', '<C-Right>', { desc = "Move words to right" })
vim.keymap.set('i', '<M-b>', '<C-Left>', { desc = "Move words to left" })
vim.keymap.set('i', '<M-l>', '<End>', { desc = "Move to end of line" })
vim.keymap.set('i', '<M-h>', '<Home>', { desc = "Move to sta of line" })
