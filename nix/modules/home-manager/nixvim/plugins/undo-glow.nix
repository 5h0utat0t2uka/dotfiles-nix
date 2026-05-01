{ pkgs, ... }:

let
  undo-glow-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "undo-glow.nvim";
    version = "unstable-25314a9";
    src = builtins.fetchGit {
      url = "https://github.com/y3owk1n/undo-glow.nvim.git";
      rev = "25314a94cdfd84a3ca62bada1f88ed00982659ac";
    };
  };

  undoGlowLua = ''
    local undo_glow_colors = {
      undo = { bg = "#4C566A" },
      redo = { bg = "#4C566A" },
      yank = { bg = "#6e596d" },
      paste = { bg = "#6e596d" },
      comment = { bg = "#4C566A" },
      search = { bg = "#4C566A" },
    }
    local function ug_opts(kind)
      return {
        hl_color = undo_glow_colors[kind],
      }
    end
  '';
in
{
  extraPlugins = [ undo-glow-nvim ];
  keymaps = [
    {
      mode = "n";
      key = "u";
      action.__raw = ''
        function()
          require("undo-glow").undo({ hl_color = { bg = "#4C566A" } })
        end
      '';
      options = {
        noremap = true;
        silent = true;
        desc = "Undo with highlight";
      };
    }
    {
      mode = "n";
      key = "U";
      action.__raw = ''
        function()
          require("undo-glow").redo({ hl_color = { bg = "#4C566A" } })
        end
      '';
      options = {
        noremap = true;
        silent = true;
        desc = "Redo with highlight";
      };
    }
    {
      mode = "n";
      key = "p";
      action.__raw = ''
        function()
          require("undo-glow").paste_below({ hl_color = { bg = "#6e596d" } })
        end
      '';
      options = {
        noremap = true;
        silent = true;
        desc = "Paste below with highlight";
      };
    }
    {
      mode = "n";
      key = "P";
      action.__raw = ''
        function()
          require("undo-glow").paste_above({ hl_color = { bg = "#6e596d" } })
        end
      '';
      options = {
        noremap = true;
        silent = true;
        desc = "Paste above with highlight";
      };
    }
    {
      mode = [ "n" "x" ];
      key = "gc";
      action.__raw = ''
        function()
          local pos = vim.fn.getpos(".")
          vim.schedule(function()
            vim.fn.setpos(".", pos)
          end)

          return require("undo-glow").comment({
            hl_color = { bg = "#4C566A" },
          })
        end
      '';
      options = {
        expr = true;
        noremap = true;
        silent = true;
        desc = "Toggle comment with highlight";
      };
    }
    {
      mode = "o";
      key = "gc";
      action.__raw = ''
        function()
          require("undo-glow").comment_textobject({
            hl_color = { bg = "#4C566A" },
          })
        end
      '';
      options = {
        noremap = true;
        silent = true;
        desc = "Comment textobject with highlight";
      };
    }
    {
      mode = "n";
      key = "gcc";
      action.__raw = ''
        function()
          return require("undo-glow").comment_line({
            hl_color = { bg = "#4C566A" },
          })
        end
      '';
      options = {
        expr = true;
        noremap = true;
        silent = true;
        desc = "Toggle comment line with highlight";
      };
    }
  ];
  extraConfigLua = ''
    ${undoGlowLua}
    require("undo-glow").setup({
      animation = {
        enabled = true,
        duration = 300,
        animation_type = "fade",
        window_scoped = true,
      },
      highlights = {
        undo = { hl_color = undo_glow_colors.undo },
        redo = { hl_color = undo_glow_colors.redo },
        yank = { hl_color = undo_glow_colors.yank },
        paste = { hl_color = undo_glow_colors.paste },
        comment = { hl_color = undo_glow_colors.comment },
        search = { hl_color = undo_glow_colors.search },
      },
      priority = 2048 * 3,
    })
    local function apply_undo_glow_highlights()
      vim.api.nvim_set_hl(0, "UgUndo", { bg = undo_glow_colors.undo.bg })
      vim.api.nvim_set_hl(0, "UgRedo", { bg = undo_glow_colors.redo.bg })
      vim.api.nvim_set_hl(0, "UgYank", { bg = undo_glow_colors.yank.bg })
      vim.api.nvim_set_hl(0, "UgPaste", { bg = undo_glow_colors.paste.bg })
      vim.api.nvim_set_hl(0, "UgComment", { bg = undo_glow_colors.comment.bg })
      vim.api.nvim_set_hl(0, "UgSearch", { bg = undo_glow_colors.search.bg })
    end

    apply_undo_glow_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("UndoGlowHighlights", { clear = true }),
      callback = apply_undo_glow_highlights,
    })
    vim.api.nvim_create_autocmd("TextYankPost", {
      group = vim.api.nvim_create_augroup("UndoGlowYank", { clear = true }),
      desc = "Highlight when yanking text",
      callback = function()
        if vim.v.event.operator == "y" then
          require("undo-glow").yank(ug_opts("yank"))
        end
      end,
    })
  '';
}
