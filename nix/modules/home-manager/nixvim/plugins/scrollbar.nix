{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    nvim-scrollbar
    nvim-hlslens
    # gitsigns-nvim
  ];

  extraConfigLua = ''
    require("scrollbar").setup({
      show = true,
      handle = { color = "#3b4252" },
      marks = {
        Search = { color = "#d08770" },
        Error = { color = "#bf616a" },
        Warn = { color = "#ebcb8b" },
        Info = { color = "#88c0d0" },
        Hint = { color = "#a3be8c" },
        Misc = { color = "#b48ead" },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        search = true,
      },
      excluded_buftypes = { "terminal", "nofile" },
      excluded_filetypes = { "neo-tree", "help", "dashboard" },
      throttle_ms = 100,
    })

    require("scrollbar.handlers.search").setup({
      override_lens = function() end,
    })
  '';
}
