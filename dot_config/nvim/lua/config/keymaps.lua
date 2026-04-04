-- normal mode keymaps
-- バッファ
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo" })
-- タブ
vim.keymap.set("n", "gk", "<Cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "gh", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "gl", "<Cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "gj", "<Cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "gJ", "<Cmd>tabclose!<CR>", { desc = "Force close tab" })
-- LSP
vim.keymap.set("n", "<Leader>lh", vim.lsp.buf.hover, { desc = "LSP Hover" })
vim.keymap.set("n", "<Leader>ld", vim.lsp.buf.definition, { desc = "LSP Definition" })
vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.references, { desc = "LSP References" })
vim.keymap.set("n", "<Leader>ln", vim.lsp.buf.rename, { desc = "LSP Rename" })

vim.keymap.set("n", "<A-h>", "b", { remap = true, silent = true, desc = "Prev word" })
vim.keymap.set("n", "<A-l>", "w", { remap = true, silent = true, desc = "Next word" })
vim.keymap.set("n", "<A-k>", "<C-u>", { remap = true, silent = true, desc = "Page up" })
vim.keymap.set("n", "<A-j>", "<C-d>", { remap = true, silent = true, desc = "Page down" })
vim.keymap.set('n', '<leader>yd', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics == 0 then
    vim.notify('No diagnostics', vim.log.levels.INFO)
    return
  end
  local messages = vim.tbl_map(function(d) return d.message end, diagnostics)
  local text = table.concat(messages, '\n')
  vim.fn.setreg('+', text)
  vim.notify('Yanked: ' .. text)
end, { desc = "Yank diagnostic message" })

-- 単語の大文字小文字を切り替える
vim.keymap.set("n", "<leader>tc", "g~iw", { remap = false, desc = "Toggle word case" })

-- 検索ハイライト解除
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
-- 単語の移動
vim.keymap.set('i', '<A-w>', '<C-Right>', { desc = "Move words to right" })
vim.keymap.set('i', '<A-b>', '<C-Left>', { desc = "Move words to left" })
vim.keymap.set('i', '<A-l>', '<End>', { desc = "Move to end of line" })
vim.keymap.set('i', '<A-h>', '<Home>', { desc = "Move to sta of line" })

-- visual mode keymaps
-- インデント
vim.keymap.set("x", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("x", ">", ">gv", { noremap = true, silent = true })
-- 選択範囲の移動
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- command mode keymaps
vim.keymap.set('c', '<c-a>', '<home>', { desc = 'Emacs like home' })
vim.keymap.set('c', '<c-e>', '<end>', { desc = 'Emacs like end' })
vim.keymap.set('c', '<M-b>', '<S-Left>', { desc = 'Word left in cmdline' })
vim.keymap.set('c', '<M-f>', '<S-Right>', { desc = 'Word right in cmdline' })
