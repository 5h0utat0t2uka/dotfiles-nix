{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ { plugin = nvim-ts-autotag; optional = true; } ];
  plugins.lz-n.plugins = [{
    __unkeyed-1 = "nvim-ts-autotag";
    event = "InsertEnter";
    after = ''
      function()
        require("nvim-ts-autotag").setup({
          opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
          per_filetype = { astro = { enable_close = true, enable_rename = true, enable_close_on_slash = false } },
        })
      end
    '';
  }];
}
