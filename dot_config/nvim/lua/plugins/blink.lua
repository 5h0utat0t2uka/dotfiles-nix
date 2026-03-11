-- return {
--   {
--     "saghen/blink.cmp",
--     version = "1.*",
--     dependencies = {
--       "rafamadriz/friendly-snippets",
--     },
--     opts = {
--       keymap = { preset = "default" },
--       appearance = {
--         nerd_font_variant = "mono",
--       },
--       completion = {
--         documentation = { auto_show = false },
--       },
--       sources = {
--         default = { "lsp", "path", "snippets", "buffer" },
--       },
--       fuzzy = {
--         implementation = "prefer_rust_with_warning",
--       },
--     },
--     opts_extend = { "sources.default" },
--   },
-- }

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "giuxtaposition/blink-cmp-copilot",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = false },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
    opts_extend = { "sources.default" },
  },
}
