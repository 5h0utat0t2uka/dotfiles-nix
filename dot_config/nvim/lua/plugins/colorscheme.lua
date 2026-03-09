return {
  "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = true
    vim.cmd.colorscheme("nord")
  end,
  config = function()
    local function apply_custom_highlights()
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#353B49" })
      vim.api.nvim_set_hl(0, "TabLine", { fg = "#4C566A", bg = "#2E3440" })
      vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#81A1C1", bg = "#2E3440" })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#2E3440" })
      vim.api.nvim_set_hl(0, "WinBar", { bg = "#2e3440", fg = "#4c566a" })
      vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#2e3440", fg = "#4c566a" })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3b4252", bg = "NONE" })
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#4c566a", bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#3b4252", bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#d8dee9", bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#d8dee9", bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#d8dee9", bg = "none" })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#d8dee9", bg = "none" })
    end

    apply_custom_highlights()

    local group = vim.api.nvim_create_augroup("MyColorschemeOverrides", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = apply_custom_highlights,
    })
  end,
}
