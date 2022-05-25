local lastplace = require("nvim-lastplace")

lastplace.setup({
  -- 以下buffer不记录
  lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
  -- 以下文件类型文件类型不记录
  lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
})
