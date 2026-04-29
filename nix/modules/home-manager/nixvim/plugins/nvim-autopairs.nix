{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ { plugin = nvim-autopairs; optional = true; } ];
  plugins.lz-n.plugins = [{
    __unkeyed-1 = "nvim-autopairs";
    event = "InsertEnter";
    after = ''
      function()
        require("nvim-autopairs").setup({ check_ts = true })
      end
    '';
  }];
}
