vim.loader.enable()

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- require configs
require("config.options")
require("config.keymaps")
require("config.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- require('vim._core.ui2').enable({
--   enable = true,
--   msg = {
--     targets = 'cmd',
--     cmd = {
--       height = 1
--     },
--     dialog = {
--       height = 1,
--     },
--     msg = {
--       height = 1,
--       timeout = 10000,
--     },
--     pager = {
--       height = 1,
--     },
--   },
-- })

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  change_detection = { notify = false },
  rocks = { enabled = false, hererocks = false },
})
