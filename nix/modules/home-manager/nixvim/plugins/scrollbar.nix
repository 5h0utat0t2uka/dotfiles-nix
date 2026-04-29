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
      handle = {
        color = "#3b4252",
      },
      marks = {
        Search = { color = "#d08770" },
        Error = { color = "#bf616a" },
        Warn = { color = "#B48EAD" },
        Info = { color = "#A3BE8C" },
        Hint = { color = "#5E81AC" },
        Misc = { color = "#EBCB8B" },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = false,
        search = true,
      },
      excluded_buftypes = {
        "terminal",
        "nofile",
      },
      excluded_filetypes = {
        "neo-tree",
        "help",
        "dashboard",
      },
      throttle_ms = 100,
    })

    require("scrollbar.handlers.search").setup({
      override_lens = function() end,
    })
  '';
}
