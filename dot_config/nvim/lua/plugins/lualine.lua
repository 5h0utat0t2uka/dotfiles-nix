return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local custom = vim.deepcopy(require("lualine.themes.nord"))
    local colors = {
      normal   = "#5E81AC",
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
          {
            "branch",
            icons_enabled = true,
            color = {
              fg = "#5E81AC",
              bg = "#2E3440",
              -- bg = "#3B4252",
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
              fg = "#5E81AC",
              bg = "#2E3440",
            }
          },
          { "diagnostics", symbols = { error = ' ', warn = ' ', info = ' ', hint = ' '} }
        },
        lualine_c = {},
        -- lualine_c = {
        --   {
        --     "filename",
        --     file_status = true,
        --     newfile_status = true,
        --     path = 1,
        --     shorting_target = 40,
        --     symbols = { unnamed = "[No Name]" },
        --     color = {
        --       fg = "#5E81AC",
        --       bg = "#2E3440",
        --     }
        --   }
        -- },
        lualine_x = {},
        -- lualine_x = {
        --   {
        --     "filetype",
        --     icons_enabled = false,
        --     colored = false,
        --     color = {
        --       fg = "#5E81AC",
        --       bg = "#2E3440",
        --     }
        --   }
        -- },
        lualine_y = {},
        lualine_z = {
          {
            "location",
            color = {
              fg = "#5E81AC",
              bg = "#2E3440",
            }
          }
        },
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            separator = { left = " ", right = "" },
            show_filename_only = true,
            icons_enabled = false,
            symbols = {
              modified = " ",
              alternate_file = "",
              directory = "",
            },
            buffers_color = {
              active   = { fg = "#2E3440", bg = "#5E81AC" },
              inactive = { fg = "#4C566A", bg = "#2E3440" },
            },
          }
        },
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
