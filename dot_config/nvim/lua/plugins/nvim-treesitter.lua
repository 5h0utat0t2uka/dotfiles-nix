return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash",
        "tsx", "json", "html", "typescript", "javascript"
      },
      auto_install = true,  -- ← 自動インストールを有効化
    })
    -- パーサーが存在する場合のみ有効化
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang then return end
        -- パーサーが利用可能か確認
        local ok = pcall(vim.treesitter.start, args.buf, lang)
        if not ok then
          return
        end
      end,
    })
  end,
}
