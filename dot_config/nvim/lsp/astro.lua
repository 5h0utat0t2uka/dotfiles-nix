return {
  filetypes = { "astro" },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    local root = config.root_dir
    if not root then
      return
    end

    local tsdk = root .. "/node_modules/typescript/lib"
    if vim.uv.fs_stat(tsdk) then
        config.init_options.typescript.tsdk = tsdk
        return
    end

    -- fallback: Nixのtscのパスから解決
    local tsc = vim.fn.trim(vim.fn.system("which tsc"))
    if tsc and tsc ~= "" then
      local nix_tsdk = vim.fn.trim(vim.fn.system("dirname $(dirname " .. tsc .. ")")) .. "/lib/node_modules/typescript/lib"
      if vim.uv.fs_stat(nix_tsdk) then
        config.init_options.typescript.tsdk = nix_tsdk
        return
      end
    end
  end,
}
