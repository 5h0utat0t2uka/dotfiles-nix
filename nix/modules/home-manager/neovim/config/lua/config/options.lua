vim.opt.clipboard:append("unnamedplus")
vim.opt.termguicolors = true
vim.opt.ttimeoutlen = 50
vim.opt.swapfile = false
vim.opt.wildmode = { "list", "full" }
vim.opt.pumborder = "rounded"
vim.opt.pumblend = 10
vim.opt.winblend = 10
-- vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }
-- vim.opt.autocomplete = true
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true
vim.opt.wildmenu = true
vim.opt.tabstop = 2
vim.opt.showtabline = 1
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 5
vim.opt.winborder = "rounded"
-- vim.o.winbar = " "
vim.opt.whichwrap = 'b,s,h,l,<,>,[,],~'
vim.opt.smartindent = true
vim.opt.showmatch = true
vim.opt.cursorline = true
vim.opt.cmdheight = 0
-- vim.opt.cmdheight = 1
vim.opt.guicursor = table.concat({
  "n-v:block",
  "i:ver50",
  "c:hor50",
  "a:blinkon500-blinkoff500",
}, ",")
