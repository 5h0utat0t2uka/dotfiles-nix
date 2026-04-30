{ ... }:

{
  plugins.lualine = {
    enable = true;
    lazyLoad.settings.event = "UIEnter";
    luaConfig.pre = ''
      local lualine_custom_theme = vim.deepcopy(require("lualine.themes.nord"))
      local lualine_colors = {
        normal   = "#81A1C1",
        insert   = "#a3be8c",
        visual   = "#b48ead",
        replace  = "#d08770",
        command  = "#bf616a",
        terminal = "#88C0D0",
        inactive = "#2E3440",
      }
      lualine_custom_theme.command = vim.deepcopy(lualine_custom_theme.normal)
      lualine_custom_theme.terminal = vim.deepcopy(lualine_custom_theme.normal)
      for mode, sections in pairs(lualine_custom_theme) do
        if sections.c then
          sections.c.bg = lualine_colors.inactive
          sections.c.fg = lualine_colors.normal
        end

        local color = lualine_colors[mode] or lualine_colors.normal
        if sections.a then
          sections.a.bg = color
          sections.a.fg = lualine_colors.inactive
          sections.a.gui = "bold"
        end
      end

      local function visual_selection_info()
        local mode = vim.fn.mode()
        if not mode:find("[vV\22]") then
          return ""
        end

        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        local start_col = vim.fn.col("v")
        local end_col = vim.fn.col(".")
        if start_line > end_line or (start_line == end_line and start_col > end_col) then
          start_line, end_line = end_line, start_line
          start_col, end_col = end_col, start_col
        end

        local line_count = math.abs(end_line - start_line) + 1
        local char_count = 0
        if mode == "V" then
          for lnum = start_line, end_line do
            char_count = char_count + vim.fn.strchars(vim.fn.getline(lnum))
          end
        else
          for lnum = start_line, end_line do
            local text = vim.fn.getline(lnum)
            local line_len = vim.fn.strchars(text)
            local s = (lnum == start_line) and start_col or 1
            local e = (lnum == end_line) and end_col or line_len
            if mode == "\22" then
              s = math.min(start_col, end_col)
              e = math.max(start_col, end_col)
            end
            s = math.max(1, s)
            e = math.max(s, e)
            char_count = char_count + vim.fn.strchars(vim.fn.strcharpart(text, s - 1, e - s + 1))
          end
        end

        local parts = {}
        if line_count >= 2 then
          table.insert(parts, string.format("%d lines", line_count))
        end
        table.insert(parts, string.format(
          "%d %s",
          char_count,
          char_count == 1 and "character" or "characters"
        ))
        return table.concat(parts, " ")
      end
    '';

    settings = {
      options = {
        always_show_tabline = true;
        theme.__raw = "lualine_custom_theme";
        section_separators = {
          left = "";
          right = "";
        };
        component_separators = {
          left = "";
          right = "";
        };
      };

      sections.__raw = ''
        {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                local map = {
                  NORMAL = "N",
                  INSERT = "I",
                  VISUAL = "V",
                  ["V-LINE"] = "V",
                  ["V-BLOCK"] = "V",
                  REPLACE = "R",
                  COMMAND = "C",
                  TERMINAL = "T",
                }
                return map[str] or str
              end,
              color = {
                fg = lualine_colors.inactive,
                gui = "bold",
              },
            },
          },
          lualine_b = {
            {
              "branch",
              icons_enabled = false,
              separator = {
                left = "",
                right = "",
              },
              fmt = function(str)
                return str ~= "" and "[" .. str .. "]" or ""
              end,
              color = {
                fg = "#81A1C1",
                bg = "#2E3440",
              },
            },
            {
              "diff",
              symbols = {
                added = "+ ",
                modified = "~ ",
                removed = "- ",
              },
              color = {
                fg = "#81A1C1",
                bg = "#2E3440",
              },
            },
            {
              "diagnostics",
              symbols = {
                error = "E ",
                warn = "W ",
                info = "I ",
                hint = "H ",
              },
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
              symbols = {
                unnamed = "[No Name]",
              },
              fmt = function(str)
                return str:gsub("/", "  ")
              end,
              color = {
                fg = "#81A1C1",
                bg = "#2E3440",
              },
            },
          },
          lualine_c = {},
          lualine_x = {
            {
              function()
                local ok, noice = pcall(require, "noice")
                if ok then
                  return noice.api.status.search.get()
                end
                return ""
              end,
              cond = function()
                local ok, noice = pcall(require, "noice")
                return ok and noice.api.status.search.has()
              end,
              color = {
                fg = "#D08770",
                bg = "#2E3440",
              },
            },
            {
              visual_selection_info,
              color = {
                fg = lualine_colors.visual,
                bg = "#2E3440",
              },
            },
          },
          lualine_y = {
            {
              "location",
              color = {
                fg = "#81A1C1",
                bg = "#2E3440",
              },
            },
          },
          lualine_z = {
            {
              "encoding",
              fmt = function(str)
                return string.upper(str)
              end,
              color = {
                fg = "#81A1C1",
                bg = "#2E3440",
              },
            },
          },
        }
      '';

      inactive_sections.__raw = ''
        {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        }
      '';
      tabline.__raw = "{}";
      winbar.__raw = "{}";
      inactive_winbar.__raw = "{}";
    };
  };
}
