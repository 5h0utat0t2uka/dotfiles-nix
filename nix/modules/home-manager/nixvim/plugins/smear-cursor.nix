{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ smear-cursor-nvim ];
  extraConfigLua = ''
    require("smear_cursor").setup({
      smear_to_cmd = false,
      stiffness = 0.5,
      trailing_stiffness = 0.5,
      matrix_pixel_threshold = 0.5,
    })
  '';
}
