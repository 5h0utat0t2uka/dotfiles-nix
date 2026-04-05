return {
  "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = true
    vim.cmd.colorscheme("nord")

    local function apply_custom_highlights()
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#353B49" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#544a59" })
      vim.api.nvim_set_hl(0, "TabLine", { fg = "#4C566A", bg = "#2E3440" })
      vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#81A1C1", bg = "#2E3440", bold = true })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#2E3440" })
      vim.api.nvim_set_hl(0, "WinBar", { bg = "#2e3440", fg = "#4c566a" })
      vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#2e3440", fg = "#4c566a" })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3b4252", bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4c566a", bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MsgArea", { fg = "#81A1C1", bg = "#2E3440" })
      vim.api.nvim_set_hl(0, "Pmenu", {
        bg = "#2E3440",
        fg = "#D8DEE9",
      })
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", {
        fg = "#4c566a",
        bg = "#2E3440",
      })
      vim.api.nvim_set_hl(0, "IncSearch", {
        fg = "#2E3440",
        bg = "#A3BE8C",
        bold = true,
      })
      vim.api.nvim_set_hl(0, "PreInsert", {
        fg = "#A3BE8C",
      })
    end

    apply_custom_highlights()

    local group = vim.api.nvim_create_augroup("NordOverrides", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = apply_custom_highlights,
    })
    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
      group = group,
      callback = function(e)
        local bg = e.event == "InsertEnter" and "#2E3440" or "#353B49"
        vim.api.nvim_set_hl(0, "CursorLine", { bg = bg })
      end,
    })
  end,
}
