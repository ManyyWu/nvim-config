local telescope = require("telescope")

local default = {
  theme = "ivy", -- dropdown,cursor,ivy
  layout_config = {
    height = 0.4,
  },
  border = false,
}

telescope.setup({
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      height = function(self, max_columns, max_lines) return max_lines end,
      width = function(self, max_columns, max_lines) return max_columns end,
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--encoding=gbk',
    },
  },
  pickers = {
    find_files  = default,
    live_grep   = default,
    grep_string = default,
    buffers     = default,
    help_tags   = default,
    oldfiles    = default,
    colorscheme = default,
    diagnostics = default,
  }
})

-- Notes:
-- 在telescope窗口中C-q打开quicklist
