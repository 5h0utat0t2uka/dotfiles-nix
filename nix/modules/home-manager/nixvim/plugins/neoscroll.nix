{ pkgs, ... }:

{
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.neoscroll-nvim;
      optional = true;
    }
  ];
  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "neoscroll.nvim";
      keys = [
        "<C-u>"
        "<C-d>"
        "<C-b>"
        "<C-f>"
        "<C-y>"
        "<C-e>"
      ];
      after = ''
        function()
          require("neoscroll").setup({
            mappings = {
              "<C-u>", "<C-d>",
              "<C-b>", "<C-f>",
              "<C-y>", "<C-e>",
            },
            easing = "quadratic",
            duration_multiplier = 0.5,
            hide_cursor = true,
            stop_eof = true,
            respect_scrolloff = false,
            cursor_scrolls_alone = true,
          })
        end
      '';
    }
  ];
}
