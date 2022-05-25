local toggleterm = require("toggleterm")

toggleterm.setup({
  open_mapping = [[<c-\>]],
  direction = "horizontal", -- tab,float,horizontal,vertical
  size = vim.o.lines * 0.4
})

vim.cmd([[
  augroup term_window_switch
  autocmd!
  autocmd TermOpen term://* lua require("keymaps").set_terminal_keymaps()
  augroup END
]])


