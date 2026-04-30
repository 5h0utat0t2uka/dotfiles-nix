{ ... }:

{
  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = false;
    settings = {
      keymap = {
        preset = "default";
        "<M-Space>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
        "<Tab>" = [
          "accept"
          "fallback"
        ];
      };
      appearance = {
        nerd_font_variant = "mono";
      };
      completion = {
        documentation = {
          auto_show = false;
        };
      };
      sources = {
        default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
        providers = {
          snippets = {
            opts = {
              search_paths.__raw = ''
                vim.api.nvim_get_runtime_file("snippets", true)
              '';
              use_label_description = true;
            };
          };
        };
      };

      fuzzy = {
        implementation = "prefer_rust_with_warning";
      };
    };
  };
  plugins.friendly-snippets.enable = true;
}
