-- ~/.config/nvim/after/lsp/astro.lua
-- return {
--   before_init = function(_, config)
--     if not (config.init_options and config.init_options.typescript) then
--       return
--     end
--     if config.init_options.typescript.tsdk and config.init_options.typescript.tsdk ~= "" then
--       return
--     end
--     local tsc = vim.fn.trim(vim.fn.system("which tsc"))
--     if tsc ~= "" then
--       local nix_tsdk = vim.fn.trim(vim.fn.system("dirname $(dirname " .. tsc .. ")")) .. "/lib/node_modules/typescript/lib"
--       if vim.uv.fs_stat(nix_tsdk) then
--         config.init_options.typescript.tsdk = nix_tsdk
--       end
--     end
--   end,
-- }

return {
  before_init = function(_, config)
    config.init_options = config.init_options or {}
    config.init_options.typescript = config.init_options.typescript or {}

    if config.init_options.typescript.tsdk and config.init_options.typescript.tsdk ~= "" then
      return
    end

    local root = config.root_dir
      or vim.fs.root(0, {
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
        ".git",
      })

    if root then
      local local_tsdk = root .. "/node_modules/typescript/lib"
      if vim.uv.fs_stat(local_tsdk) then
        config.init_options.typescript.tsdk = local_tsdk
        return
      end
    end

    local tsc = vim.fn.exepath("tsc")
    if tsc ~= "" then
      local tsc_bin_dir = vim.fs.dirname(tsc)
      local ts_prefix = vim.fs.dirname(vim.fs.dirname(tsc_bin_dir))
      local nix_tsdk = ts_prefix .. "/lib/node_modules/typescript/lib"

      if vim.uv.fs_stat(nix_tsdk) then
        config.init_options.typescript.tsdk = nix_tsdk
        return
      end
    end
  end,
}
