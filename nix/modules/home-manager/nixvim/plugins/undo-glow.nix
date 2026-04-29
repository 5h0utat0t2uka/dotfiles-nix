{ pkgs, ... }:
{
  # flash.nvim の s mapping から呼ばれるため start plugin 扱い。
  extraPlugins = with pkgs.vimPlugins; [ undo-glow-nvim ];
  extraConfigLua = ''
    require("undo-glow").setup({
      animation = { enabled = true, duration = 300, animation_type = "fade", window_scoped = true },
      highlights = {
        undo  = { hl_color = { bg = "#567b84" } },
        redo  = { hl_color = { bg = "#567b84" } },
        yank  = { hl_color = { bg = "#6e596d" } },
        paste = { hl_color = { bg = "#6e596d" } },
        comment = { hl_color = { bg = "#4C566A" } },
        search  = { hl_color = { bg = "#8a5c4a" } },
      },
    })

    local api = require("undo-glow.api")
    local orig = api.highlight_region_enhanced
    api.highlight_region_enhanced = function(o)
      if o.s_row == 0 and o.e_row == 0 and o.e_col == 1 then return end
      orig(o)
    end

    vim.keymap.set("n", "u", function() require("undo-glow").undo() end, { noremap = true })
    vim.keymap.set("n", "U", function() require("undo-glow").redo() end, { noremap = true })
    vim.keymap.set("n", "p", function() require("undo-glow").paste_below() end, { noremap = true })
    vim.keymap.set("n", "P", function() require("undo-glow").paste_above() end, { noremap = true })
    vim.keymap.set({ "n", "x" }, "gc", function()
      local pos = vim.fn.getpos(".")
      vim.schedule(function() vim.fn.setpos(".", pos) end)
      return require("undo-glow").comment()
    end, { desc = "Toggle comment with highlight", expr = true, noremap = true })
    vim.keymap.set("n", "gcc", function() return require("undo-glow").comment_line() end, { desc = "Toggle comment line with highlight", expr = true, noremap = true })

    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "Highlight when yanking (copying) text",
      callback = function()
        if vim.v.event.operator == "y" then require("undo-glow").yank() end
      end,
    })
  '';
}
