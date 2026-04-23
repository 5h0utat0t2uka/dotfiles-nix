return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      ".git",
    })
    if root then
      on_dir(root)
      return
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(name)
    if dir and dir ~= "" then
      on_dir(dir)
    end
  end,
}
