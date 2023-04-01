local global = require("global")
local spectre = require("spectre")

spectre.setup({
  open_cmd = 'new', -- 水平分割
  mapping = {
    ['toggle_gbk_encoding'] = {
      map = "tg",
      cmd = "<cmd>lua require('spectre').change_options('gbk')<CR>",
      desc = "toggle gbk encoding"
    },
  },
  find_engine = {
    ['rg'] = {
      args = {
        '--pre=' .. global.bin_path .. '/rgpre',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
      },
      options = {
        ['gbk'] = {
          value="--encoding=gbk",
          desc="useing GBK",
          icon="[G]"
        },
      }
    },
  }
})
