{ pkgs, ... }:

{
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.nvim-scrollbar;
      optional = true;
    }
    {
      plugin = pkgs.vimPlugins.nvim-hlslens;
      optional = true;
    }
  ];
  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "nvim-scrollbar";
      event = "DeferredUIEnter";
      after = ''
        function()
          pcall(vim.cmd.packadd, "nvim-hlslens")
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
        end
      '';
    }
  ];
}
