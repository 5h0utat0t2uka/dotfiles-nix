# nix/modules/home-manager/nixvim/plugins/telescope.nix
{ ... }:

{
  plugins.telescope = {
    enable = true;
    lazyLoad.settings = {
      cmd = "Telescope";
      keys = [
        {
          __unkeyed-1 = "<leader>ff";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").find_files({
                hidden = false;
                disable_devicons = true;
              })
            end
          '';
          desc = "Files";
        }
        {
          __unkeyed-1 = "<leader>fn";
          __unkeyed-2.__raw = ''
            function()
              local telescope = require("telescope")
              pcall(telescope.load_extension, "noice")
              telescope.extensions.noice.noice({
                initial_mode = "normal",
              })
            end
          '';
          desc = "Noice";
        }
        {
          __unkeyed-1 = "<leader>fg";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").live_grep()
            end
          '';
          desc = "Grep";
        }
        {
          __unkeyed-1 = "<leader>fb";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").buffers()
            end
          '';
          desc = "Buffers";
        }
        {
          __unkeyed-1 = "<leader>fr";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").registers()
            end
          '';
          desc = "Registers";
        }
        {
          __unkeyed-1 = "<leader>gs";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").git_status()
            end
          '';
          desc = "Git status";
        }
        {
          __unkeyed-1 = "<leader>gc";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").git_commits()
            end
          '';
          desc = "Git commits";
        }
        {
          __unkeyed-1 = "<leader>gb";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").git_branches()
            end
          '';
          desc = "Git branches";
        }
        {
          __unkeyed-1 = "<leader>fh";
          __unkeyed-2.__raw = ''
            function()
              require("telescope.builtin").help_tags()
            end
          '';
          desc = "Help tags";
        }
        {
          __unkeyed-1 = "<leader>ft";
          __unkeyed-2.__raw = ''
            function()
              require("lz.n").trigger_load("todo-comments.nvim")
              local telescope = require("telescope")
              pcall(telescope.load_extension, "todo-comments")
              telescope.extensions["todo-comments"].todo({
                initial_mode = "normal",
              })
            end
          '';
          desc = "Todo";
        }
      ];
    };

    extensions.fzf-native = {
      enable = true;
      settings = {
        fuzzy = true;
        override_generic_sorter = true;
        override_file_sorter = true;
        case_mode = "smart_case";
      };
    };

    settings = {
      defaults = {
        border = true;
        winblend = 10;
        prompt_prefix = "❯ ";
        selection_caret = "❯ ";
        entry_prefix = "  ";
        color_devicons = false;
        layout_strategy = "horizontal";
        layout_config = {
          width = 0.80;
          height = 0.70;
          preview_width = 0.5;
          prompt_position = "bottom";
        };
        file_ignore_patterns = [
          "^.git/"
          "^.next/"
          "^.cache/"
          "^.pnpm-store/"
          "^.zsh_sessions/"
          "node_modules/"
          "Library/"
          "Movies/"
          "Pictures/"
          "Music/"
          ".DS_Store"
        ];
        vimgrep_arguments = [
          "rg"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
          "--hidden"
        ];
      };
      pickers = {
        find_files = {
          initial_mode = "normal";
          disable_devicons = true;
        };
        live_grep = {
          initial_mode = "normal";
        };
        buffers = {
          initial_mode = "normal";
          sort_mru = true;
          ignore_current_buffer = true;
          mappings = {
            n.dd.__raw = "require('telescope.actions').delete_buffer";
            i."<C-d>".__raw = "require('telescope.actions').delete_buffer";
          };
        };
        registers = {
          initial_mode = "normal";
          mappings = {
            n.dd.__raw = ''
              function(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                current_picker:delete_selection(function(selection)
                  vim.fn.setreg(selection.value, "")
                  vim.cmd("wshada!")
                end)
              end
            '';
          };
        };
      };
    };
  };
}
