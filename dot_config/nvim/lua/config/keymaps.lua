-- ~/.config/nvim/lua/config/keymaps.lua

vim.keymap.set("n", "gk", "<Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "gh", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "gl", "<Cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "gj", "<Cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "gJ", "<Cmd>tabclose!<CR>", { desc = "Force close tab" })