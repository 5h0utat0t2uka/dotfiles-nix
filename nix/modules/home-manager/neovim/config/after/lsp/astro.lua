return {
  before_init = function(_, config)
    config.init_options = config.init_options or {}
    config.init_options.typescript = config.init_options.typescript or {}
    if config.init_options.typescript.tsdk then
      return
    end

    local root = config.root_dir or vim.fs.root(0, {
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      ".git",
    })
    if not root then
      return
    end

    local tsdk = root .. "/node_modules/typescript/lib"
    if vim.uv.fs_stat(tsdk) then
      config.init_options.typescript.tsdk = tsdk
    end
  end,
}
