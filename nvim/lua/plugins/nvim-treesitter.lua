local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  -- 安装language parser
  ensure_installed = {"html", "css", "vim", "lua", "javascript", "typescript", "tsx"},
  -- 启用代码高亮功能
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true, -- 可能导致输入变慢
  },
  -- 启用增量选择
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>",
      scope_incremental = "<TAB>",
    }
  },
  -- 启用基于Treesitter的代码格式化(=/gg=G)
  indent = {
    enable = true
  },
})

require('nvim-treesitter.configs').setup {
  endwise = {
    enable = true,
  }
}
