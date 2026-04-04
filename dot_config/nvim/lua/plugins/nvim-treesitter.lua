-- return {
--   "nvim-treesitter/nvim-treesitter",
--   lazy = false,
--   build = ":TSUpdate",
--   config = function()
--     local treesitter = require("nvim-treesitter")
--     treesitter.setup()
--     treesitter.install({
--       "lua", "vim", "vimdoc", "query",
--       "typescript", "tsx", "json", "javascript", "html", "css", "nix", "astro"
--     })

--     vim.api.nvim_create_autocmd("FileType", {
--       pattern = {
--         "lua", "vim", "typescript", "tsx",
--         "json", "javascript", "html", "css", "astro"
--       },
--       callback = function()
--         vim.treesitter.start()
--         vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--       end,
--     })

--     vim.api.nvim_create_autocmd("FileType", {
--       pattern = "nix",
--       callback = function()
--         vim.treesitter.start()
--         vim.bo.indentexpr = ""
--       end,
--     })
--   end,
-- }
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "lua", "vim", "vimdoc", "query",
      "typescript", "tsx", "json", "javascript",
      "html", "css", "nix", "astro",
      "markdown", "markdown_inline",
      "just", "make", "yaml", "toml",
      "bash", "zsh", "dockerfile",
      "gitignore"
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "vim", "vimdoc", "query",
        "typescript", "tsx", "json", "javascript",
        "html", "css", "nix", "astro",
        "markdown",
        "just", "make", "yaml", "toml",
        "bash", "zsh", "dockerfile",
        "gitignore",
      },
      callback = function(args)
        vim.treesitter.start(args.buf)
      end,
    })
  end,
}
