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
            stiffness = 0.8,
            trailing_stiffness = 0.6,
            stiffness_insert_mode = 0.7,
            trailing_stiffness_insert_mode = 0.7,
            damping = 0.95,
            damping_insert_mode = 0.95,
            distance_stop_animating = 0.5,
            time_interval = 7,
            -- stiffness = 0.5,
            -- trailing_stiffness = 0.5,
            -- matrix_pixel_threshold = 0.5,
          })
        end
      '';
    }
  ];
}
