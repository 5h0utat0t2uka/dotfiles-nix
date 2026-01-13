return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local custom = vim.deepcopy(require("lualine.themes.nord"))
    local colors = {
      normal   = "#81a1c1",
      insert   = "#a3be8c",
      visual   = "#b48ead",
      replace  = "#d08770",
      command  = "#bf616a",
      inactive = "#2E3440",
    }
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
        theme = custom,
        section_separators = {
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
                VLINE   = "VL",
                VBLOCK  = "VB",
                REPLACE = "R",
                COMMAND = "C",
                TERMINAL= "T",
              }
              return map[str] or str
            end,
            color = {
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
          {
            "branch",
            icons_enabled = false,
            color = {
              fg = "#81A1C1",
              bg = "#3B4252",
            }
          },
          {
            "diff",
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            color = {
              fg = "#81A1C1",
              bg = "#3B4252",
            }
          },
          { "diagnostics", symbols = { error = ' ', warn = ' ', info = ' ', hint = ' '} }
        },
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 1,
            shorting_target = 40,
            symbols = { unnamed = "[Unnamed]" },
            color = {
              fg = "#81A1C1",
              bg = "#2E3440",
            }
          }
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          {
            "location",
            color = {
              fg = "#81A1C1",
              bg = "#2E3440",
            }
          }
        },
      },
    })
  end,
}
