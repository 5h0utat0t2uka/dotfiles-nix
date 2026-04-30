{ pkgs, ... }:

{
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.smear-cursor-nvim;
      optional = true;
    }
  ];
  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "smear-cursor.nvim";
      event = "CursorMoved";
      after = ''
        function()
          require("smear_cursor").setup({
            smear_to_cmd = false,
            stiffness = 0.5,
            trailing_stiffness = 0.5,
            matrix_pixel_threshold = 0.5,
          })
        end
      '';
    }
  ];
}
