{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    { plugin = blink-cmp; optional = true; }
    friendly-snippets
  ];
  plugins.lz-n.plugins = [{
    __unkeyed-1 = "blink.cmp";
    event = "InsertEnter";
    after = ''
      function()
        require("blink.cmp").setup({
          keymap = {
            preset = "default",
            ["<M-Space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<Tab>"] = { "accept", "fallback" },
          },
          appearance = { nerd_font_variant = "mono" },
          completion = { documentation = { auto_show = false } },
          sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            providers = { snippets = { opts = { use_label_description = true } } },
          },
          fuzzy = { implementation = "prefer_rust_with_warning" },
        })
      end
    '';
  }];
}
