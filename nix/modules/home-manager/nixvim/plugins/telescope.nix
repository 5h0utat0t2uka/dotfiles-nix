{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    telescope-nvim
    plenary-nvim
    telescope-fzf-native-nvim
  ];

  extraConfigLua = ''
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        border = true,
        winblend = 10,
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        color_devicons = false,
        entry_prefix = "  ",
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.80,
          height = 0.70,
          preview_width = 0.5,
          prompt_position = "bottom",
        },
        file_ignore_patterns = {
          "^.git/",
          "^.next/",
          "^.cache/",
          "^.pnpm-store/",
          "^.zsh_sessions/",
          "node_modules/",
          "Library/",
          "Movies/",
          "Pictures/",
          "Music/",
          ".DS_Store",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
      pickers = {
        find_files = {
          initial_mode = "normal",
        },
        buffers = {
          initial_mode = "normal",
          sort_mru = true,
          ignore_current_buffer = true,
          mappings = {
            n = { ["dd"] = actions.delete_buffer },
            i = { ["<C-d>"] = actions.delete_buffer },
          },
        },
        registers = {
          initial_mode = "normal",
          mappings = {
            n = {
              ["dd"] = function(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                current_picker:delete_selection(function(selection)
                  vim.fn.setreg(selection.value, "")
                  vim.cmd("wshada!")
                end)
              end,
            },
          },
        },
      },
    })

    require("telescope").load_extension("fzf")

    local b = function(fn, opts)
      return function() require("telescope.builtin")[fn](opts) end
    end

    vim.keymap.set("n", "<leader>ff", b("find_files", { hidden = false }), { desc = "Files" })
    vim.keymap.set("n", "<leader>fg", b("live_grep"), { desc = "Grep" })
    vim.keymap.set("n", "<leader>fb", b("buffers"), { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fr", b("registers"), { desc = "Registers" })
    vim.keymap.set("n", "<leader>gs", b("git_status"), { desc = "Git status" })
    vim.keymap.set("n", "<leader>gc", b("git_commits"), { desc = "Git commits" })
    vim.keymap.set("n", "<leader>gb", b("git_branches"), { desc = "Git branches" })
    vim.keymap.set("n", "<leader>fh", b("help_tags"), { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fG", function()
      require("telescope.builtin").live_grep({
        additional_args = function()
          return { "--hidden", "-uu" }
        end,
      })
    end, { desc = "Grep includes hidden/ignored" })
  '';
}
