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
      "gitignore", "regex"
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "vim", "vimdoc", "query",
        "typescript", "tsx", "json", "javascript",
        "html", "css", "nix", "astro",
        "markdown",
        "just", "make", "yaml", "toml",
        "bash", "zsh", "dockerfile",
        "gitignore", "regex"
      },
      callback = function(args)
        vim.treesitter.start(args.buf)
      end,
    })
  end,
}
