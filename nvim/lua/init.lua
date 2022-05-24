local global = require("global")

-- 插件
require("plugins")

-- 按键绑定
require("keymaps")

-- 自定义配置
require("config")

-- 自动重载配置
local auto_reload_config = vim.api.nvim_create_augroup("auto_reload_config", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.lua" },
  callback = require("core.reload").auto_reload_config,
  group = auto_reload_config,
})

--_G.__is_log = true
