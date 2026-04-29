{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ { plugin = nvim-colorizer-lua; optional = true; } ];
  plugins.lz-n.plugins = [{
    __unkeyed-1 = "nvim-colorizer.lua";
    event = [ "BufReadPre" "BufNewFile" ];
    after = ''
      function()
        require("colorizer").setup({
          filetypes = { "css", "scss", "astro", "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
          user_default_options = {
            names = true, RGB = true, RRGGBB = true, RRGGBBAA = true, AARRGGBB = true,
            rgb_fn = true, hsl_fn = true, css = true, css_fn = true, tailwind = true,
            mode = "virtualtext", virtualtext = "■", always_update = false,
          },
        })
      end
    '';
  }];
}
