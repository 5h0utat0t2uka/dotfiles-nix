-- ~/.config/nvim/after/lsp/astro.lua
return {
  before_init = function(_, config)
    if not (config.init_options and config.init_options.typescript) then
      return
    end
    if config.init_options.typescript.tsdk and config.init_options.typescript.tsdk ~= "" then
      return
    end
    local tsc = vim.fn.trim(vim.fn.system("which tsc"))
    if tsc ~= "" then
      local nix_tsdk = vim.fn.trim(vim.fn.system("dirname $(dirname " .. tsc .. ")")) .. "/lib/node_modules/typescript/lib"
      if vim.uv.fs_stat(nix_tsdk) then
        config.init_options.typescript.tsdk = nix_tsdk
      end
    end
  end,
}
