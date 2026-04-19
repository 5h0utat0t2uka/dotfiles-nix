return {
  "karb94/neoscroll.nvim",
  opts = {
    mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
      '<C-u>', '<C-d>',
      '<C-b>', '<C-f>',
      '<C-y>', '<C-e>',
      'zt', 'zz', 'zb',
    },
    easing = "quadratic",
    duration_multiplier = 0.5,
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
  },
}
