return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TodoTelescope",
    "TodoTrouble",
    "TodoQuickFix",
    "TodoLocList",
  },
  keys = {
    { "<leader>ft", function() vim.cmd("TodoTelescope initial_mode=normal") end, mode = "n", desc = "Todo" },
  },
  opts = {
    signs = false,
    keywords = {
      FIX = { icon = "", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = "", color = "hint" },
      HACK = { icon = "", color = "warning" },
      WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = "", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = "", color = "info", alt = { "INFO" } },
      TEST = { icon = "", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    colors = {
      error = { "#BF616A" },
      warning = { "#D08770" },
      info = { "#81A1C1" },
      hint = { "#A3BE8C" },
      default = { "#B48EAD" },
      test = { "#EBCB8B" },
    },
  },
  config = function(_, opts)
    require("todo-comments").setup(opts)
    local function darken_hex(hex)
      hex = hex:gsub("#", "")
      return string.format("#%02x%02x%02x",
        math.min(255, tonumber(hex:sub(1, 2), 16) / 1.4),
        math.min(255, tonumber(hex:sub(3, 4), 16) / 1.4),
        math.min(255, tonumber(hex:sub(5, 6), 16) / 1.4))
    end
    local function override_todo_keyword_fg()
      for keyword, def in pairs(opts.keywords) do
        local hex = opts.colors[def.color][1]
        local group = "TodoBg" .. keyword
        local current = vim.api.nvim_get_hl(0, { name = group, link = false })
        vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", current, {
          fg = darken_hex(hex)
        }))
      end
    end
    override_todo_keyword_fg()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = override_todo_keyword_fg,
    })
  end
}
