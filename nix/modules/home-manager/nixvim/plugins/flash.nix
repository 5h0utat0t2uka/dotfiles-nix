{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [ { plugin = flash-nvim; optional = true; } ];
  plugins.lz-n.plugins = [{
    __unkeyed-1 = "flash.nvim";
    event = "VeryLazy";
    keys = [
      { __unkeyed-1 = "s"; __unkeyed-2 = ""; mode = [ "n" "x" "o" ]; desc = "Flash jump with highlight"; }
      { __unkeyed-1 = "S"; __unkeyed-2 = "<cmd>lua require(\"flash\").treesitter()<CR>"; mode = [ "n" "x" "o" ]; desc = "Flash Treesitter"; }
      { __unkeyed-1 = "r"; __unkeyed-2 = "<cmd>lua require(\"flash\").remote()<CR>"; mode = "o"; desc = "Remote Flash"; }
      { __unkeyed-1 = "R"; __unkeyed-2 = "<cmd>lua require(\"flash\").treesitter_search()<CR>"; mode = [ "o" "x" ]; desc = "Treesitter Search"; }
      { __unkeyed-1 = "<c-s>"; __unkeyed-2 = "<cmd>lua require(\"flash\").toggle()<CR>"; mode = "c"; desc = "Toggle Flash Search"; }
    ];
    after = ''
      function()
        require("flash").setup({ modes = { search = { enabled = true } } })
        vim.keymap.set({ "n", "x", "o" }, "s", function() require("undo-glow").flash_jump({}) end, { desc = "Flash jump with highlight" })
        vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
        vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
        vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
        vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
      end
    '';
  }];
}
