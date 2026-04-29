{ ... }:

{
  plugins.hlchunk = {
    enable = true;
    lazyLoad.settings = {
      event = [
        "BufReadPost"
        "BufNewFile"
      ];
    };
    settings = {
      chunk = {
        enable = true;
        use_treesitter = false;
        style = [
          { fg = "#4C566A"; }
          { fg = "#D08770"; }
        ];
        chars = {
          horizontal_line = "─";
          vertical_line = "│";
          left_top = "┌";
          left_bottom = "└";
          right_arrow = "─";
        };
      };
      indent = {
        enable = true;
        chars = [ "│" ];
        style = [
          { fg = "#3B4252"; }
        ];
      };
    };
  };
}

# { pkgs, ... }:

# {
#   extraPlugins = with pkgs.vimPlugins; [
#     hlchunk-nvim
#   ];

#   extraConfigLua = ''
#     require("hlchunk").setup({
#       chunk = {
#         enable = true,
#         use_treesitter = false,
#         style = {
#           { fg = "#4C566A" },
#           { fg = "#D08770" },
#         },
#         chars = {
#           horizontal_line = "─",
#           vertical_line = "│",
#           left_top = "┌",
#           left_bottom = "└",
#           right_arrow = "─",
#         },
#       },
#       indent = {
#         enable = true,
#         chars = { "│" },
#         style = { { fg = "#3B4252" } },
#       },
#     })
#   '';
# }
