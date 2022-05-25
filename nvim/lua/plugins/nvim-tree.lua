local ntree = require("nvim-tree")

ntree.setup({
  auto_reload_on_write = true,  -- 自动刷新
  open_on_tab = true,           -- 当文件树打开时，新建标签时打开文件树
  git = {
    enable = true,
    ignore = false,              -- 显示忽略的文件
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
})
