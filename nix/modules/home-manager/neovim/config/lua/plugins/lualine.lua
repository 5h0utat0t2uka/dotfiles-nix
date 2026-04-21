return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local custom = vim.deepcopy(require("lualine.themes.nord"))
    local colors = {
      normal   = "#81A1C1",
      insert   = "#a3be8c",
      visual   = "#b48ead",
      replace  = "#d08770",
      command  = "#bf616a",
      inactive = "#2E3440",
    }
    local function visual_selection_info()
      local mode = vim.fn.mode()
      -- visual / visual-line / visual-block のときだけ表示
      if not mode:find("[vV\22]") then
        return ""
      end
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")
      local start_col = vim.fn.col("v")
      local end_col = vim.fn.col(".")
      -- 逆方向選択もあるので正規化
      if start_line > end_line or (start_line == end_line and start_col > end_col) then
        start_line, end_line = end_line, start_line
        start_col, end_col = end_col, start_col
      end

      local line_count = math.abs(end_line - start_line) + 1
      local char_count = 0
      if mode == "V" then
        -- 行選択: 各行全体を文字数カウント
        for lnum = start_line, end_line do
          char_count = char_count + vim.fn.strchars(vim.fn.getline(lnum))
        end
      else
        -- 文字選択 / 矩形選択
        for lnum = start_line, end_line do
          local text = vim.fn.getline(lnum)
          local line_len = vim.fn.strchars(text)
          local s = (lnum == start_line) and start_col or 1
          local e = (lnum == end_line) and end_col or line_len
          if mode == "\22" then
            -- visual block は各行で同じ列範囲を数える
            s = math.min(start_col, end_col)
            e = math.max(start_col, end_col)
          end

          -- col() は 1-based。charpart は 0-based なので補正
          s = math.max(1, s)
          e = math.max(s, e)
          char_count = char_count + vim.fn.strchars(
            vim.fn.strcharpart(text, s - 1, e - s + 1)
          )
        end
      end

      local parts = {}
      if line_count >= 2 then
        table.insert(parts, string.format("%d lines", line_count))
      end
      table.insert(
        parts,
        string.format(
          "%d %s",
          char_count,
          char_count == 1 and "character" or "characters"
        )
      )
      return table.concat(parts, " ")
    end

    for mode, sections in pairs(custom) do
      if sections.c then
        sections.c.bg = colors.inactive
        sections.c.fg = colors.normal
      end
      local color = colors[mode] or colors.normal
      if sections.a then sections.a.bg = color end
      -- if sections.z then sections.z.bg = color end
    end

    require("lualine").setup({
      options = {
        always_show_tabline = true,
        theme = custom,
        section_separators = {
          left = "",
          right = "",
        },
        component_separators = {
          left = "",
          right = "",
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              local map = {
                NORMAL  = "N",
                INSERT  = "I",
                VISUAL  = "V",
                ["V-LINE"]   = "V",
                ["V-BLOCK"]  = "V",
                REPLACE = "R",
                COMMAND = "C",
                TERMINAL= "T",
              }
              return map[str] or str
            end,
            color = {
              fg = colors.inactive,
              gui = "bold",
            },
          },
        },
        -- lualine_a = {
        --   {
        --     "mode",
        --     color = {
        --       gui = "none",
        --     },
        --   },
        -- },
        lualine_b = {
          -- {
          --   function()
          --     return " "
          --   end,
          --   color = { bg = "#2E3440", fg = "#2E3440" },
          --   padding = { left = 0, right = 0 },
          -- },
          {
            "branch",
            icons_enabled = false,
            -- icon = "󰘬",
            separator = { left = "", right = "" },
            fmt = function(str) return str ~= "" and "[" .. str .. "]" or "" end,
            -- fmt = function(str)
            --   return string.upper(str)
            -- end,
            color = {
              fg = "#81A1C1",
              bg = "#2E3440",
              -- bg = "#3B4252",
            }
          },
          {
            "diff",
            symbols = {
              added = '+ ',
              modified = '~ ',
              removed = '- ',
            },
            color = {
              fg = "#81A1C1",
              bg = "#2E3440",
            }
          },
          {
            "diagnostics",
            -- symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            symbols = {error = 'E ', warn = 'W ', info = 'I ', hint = 'H '},
            color = {
              bg = "#2E3440",
            },
          },
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 1,
            shorting_target = 40,
            symbols = { unnamed = "[No Name]" },
            fmt = function(str)
              -- return str:gsub("/", "  ")
              return str:gsub("/", "  ")
            end,
            -- padding = { left = 1, right = 1 },
            -- separator = { left = " ", right = " " },
            color = {
              fg = "#81A1C1",
              bg = "#2E3440",
              -- fg = "#2E3440",
              -- bg = "#4C566A",
              -- gui = "bold",
            }
          },
        },
        -- lualine_c = {},
        lualine_c = {

          -- {
          --   "filetype",
          --   icon_only = true,
          --   colored = false,
          --   padding = { left = 1, right = 1 },
          --   color = {
          --     fg = "#81A1C1",
          --     bg = "#2E3440",
          --   },
          -- },

          -- {
          --   "filename",
          --   file_status = false,
          --   newfile_status = true,
          --   path = 0,
          --   shorting_target = 40,
          --   symbols = { unnamed = "[No Name]" },
          --   padding = { left = 1, right = 1 },
          --   separator = { left = " ", right = " " },
          --   color = {
          --     fg = "#2E3440",
          --     bg = "#4C566A",
          --     gui = "bold",
          --   }
          -- },

          -- {
          --   "diff",
          --   symbols = {
          --     added = ' ',
          --     modified = ' ',
          --     removed = ' ',
          --   },
          --   color = {
          --     fg = "#81A1C1",
          --     bg = "#2E3440",
          --   }
          -- },
          -- { "diagnostics", symbols = { error = ' ', warn = ' ', info = ' ', hint = ' '} }
        },
        -- lualine_x = {},
        lualine_x = {
          {
            require("noice").api.status.search.get,
            cond = require("noice").api.status.search.has,
            color = { fg = "#D08770", bg = "#2E3440" },
          },
          {
            visual_selection_info,
            color = {
              fg = colors.visual,
              bg = "#2E3440",
            }
          }
        },
        lualine_y = {
          {
            "location",
            -- fmt = function(str)
            --   return string.upper(str)
            -- end,
            color = {
              fg = "#81A1C1",
              bg = "#2E3440",
            }
          }
        },
        -- lualine_z = {},
        lualine_z = {
          {
            "encoding",
            fmt = function(str)
              return string.upper(str)
            end,
            color = {
              fg = "#81A1C1",
              bg = "#2E3440",
            }
          }
        },
      },
      tabline = {
        -- lualine_a = {
        --   {
        --     "buffers",
        --     separator = { left = " ", right = " " },
        --     show_filename_only = true,
        --     icons_enabled = false,
        --     symbols = {
        --       modified = " ",
        --       alternate_file = "",
        --       directory = "",
        --     },
        --     buffers_color = {
        --       active   = { fg = "#2E3440", bg = "#81A1C1" },
        --       inactive = { fg = "#81A1C1", bg = "#2E3440" },
        --     },
        --   }
        -- },
        -- lualine_z = {
        --   {
        --     "tabs",
        --     separator = { left = "", right = " " },
        --   }
        -- }
      }
    })
  end,
}
