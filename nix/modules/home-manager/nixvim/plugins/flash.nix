{ ... }:

{
  plugins.flash = {
    enable = true;
    lazyLoad.settings = {
      keys = [
        {
          __unkeyed-1 = "s";
          mode = [ "n" "x" "o" ];
          __unkeyed-2.__raw = ''
            function()
              local ok, undo_glow = pcall(require, "undo-glow")
              if ok and undo_glow.flash_jump then
                undo_glow.flash_jump({})
              else
                require("flash").jump()
              end
            end
          '';
          desc = "Flash jump with highlight";
        }
        {
          __unkeyed-1 = "S";
          mode = [ "n" "x" "o" ];
          __unkeyed-2.__raw = ''
            function()
              require("flash").treesitter()
            end
          '';
          desc = "Flash Treesitter";
        }
        {
          __unkeyed-1 = "r";
          mode = "o";
          __unkeyed-2.__raw = ''
            function()
              require("flash").remote()
            end
          '';
          desc = "Remote Flash";
        }
        {
          __unkeyed-1 = "R";
          mode = [ "o" "x" ];
          __unkeyed-2.__raw = ''
            function()
              require("flash").treesitter_search()
            end
          '';
          desc = "Treesitter Search";
        }
        {
          __unkeyed-1 = "<C-s>";
          mode = "c";
          __unkeyed-2.__raw = ''
            function()
              require("flash").toggle()
            end
          '';
          desc = "Toggle Flash Search";
        }
      ];
    };
    settings = {
      modes = {
        search = {
          enabled = true;
        };
      };
    };
  };
}

# { pkgs, ... }:

# {
#   extraPlugins = with pkgs.vimPlugins; [
#     flash-nvim
#   ];

#   extraConfigLua = ''
#     require("flash").setup({
#       modes = {
#         search = {
#           enabled = true,
#         },
#       },
#     })

#     vim.keymap.set({ "n", "x", "o" }, "s", function()
#       local ok, undo_glow = pcall(require, "undo-glow")
#       if ok and undo_glow.flash_jump then
#         undo_glow.flash_jump({})
#       else
#         require("flash").jump()
#       end
#     end, { desc = "Flash jump with highlight" })

#     vim.keymap.set({ "n", "x", "o" }, "S", function()
#       require("flash").treesitter()
#     end, { desc = "Flash Treesitter" })

#     vim.keymap.set("o", "r", function()
#       require("flash").remote()
#     end, { desc = "Remote Flash" })

#     vim.keymap.set({ "o", "x" }, "R", function()
#       require("flash").treesitter_search()
#     end, { desc = "Treesitter Search" })

#     vim.keymap.set("c", "<c-s>", function()
#       require("flash").toggle()
#     end, { desc = "Toggle Flash Search" })
#   '';
# }
