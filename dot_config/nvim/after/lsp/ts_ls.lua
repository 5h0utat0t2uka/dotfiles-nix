-- after/lsp/ts_ls.lua
return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      ".git",
    })
    on_dir(root)
  end,

  reuse_client = function(client, config)
    return client.name == config.name
  end,
}
