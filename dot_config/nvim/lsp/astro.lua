-- return {
--   filetypes = { "astro" },
-- }

return {
  filetypes = { "astro" },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    local root = config.root_dir
    if root then
      config.init_options.typescript.tsdk = root .. "/node_modules/typescript/lib"
    end
  end,
}
