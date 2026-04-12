return {
  "y3owk1n/undo-glow.nvim",
  event = { "VeryLazy" },
  opts = {
    animation = {
      enabled = true,
      duration = 300,
      animation_type = "fade",
      window_scoped = true,
    },
    highlights = {
      undo  = { hl_color = { bg = "#4a7d8f" } },
      redo  = { hl_color = { bg = "#7a4f3f" } },
      yank  = { hl_color = { bg = "#6e596d" } },
      paste = { hl_color = { bg = "#61754e" } },
      comment = { hl_color = { bg = "#4C566A" } },
      search  = { hl_color = { bg = "#8a5c4a" } },
    },
  },
  keys = {
    { "u", function() require("undo-glow").undo() end,        mode = "n", noremap = true },
    { "U", function() require("undo-glow").redo() end,        mode = "n", noremap = true },
    { "p", function() require("undo-glow").paste_below() end, mode = "n", noremap = true },
    { "P", function() require("undo-glow").paste_above() end, mode = "n", noremap = true },
    {
      "gc",
      function()
        local pos = vim.fn.getpos(".")
        vim.schedule(function()
          vim.fn.setpos(".", pos)
        end)
        return require("undo-glow").comment()
      end,
      mode = { "n", "x" },
      desc = "Toggle comment with highlight",
      expr = true,
      noremap = true,
    },
    {
      "gcc",
      function() return require("undo-glow").comment_line() end,
      mode = "n",
      desc = "Toggle comment line with highlight",
      expr = true,
      noremap = true,
    },
  },
  config = function(_, opts)
    require("undo-glow").setup(opts)

    -- setup() 後にパッチを当てる
    local api = require("undo-glow.api")
    local orig = api.highlight_region_enhanced
    api.highlight_region_enhanced = function(o)
      if o.s_row == 0 and o.e_row == 0 and o.e_col == 1 then
        return
      end
      orig(o)
    end
    -- vim.api.nvim_create_autocmd("TextYankPost", {
    --   callback = function()
    --     require("undo-glow").yank()
    --   end,
    -- })
    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "Highlight when yanking (copying) text",
      callback = function()
        if vim.v.event.operator == "y" then
          require("undo-glow").yank()
        end
      end,
    })
  end,
}
