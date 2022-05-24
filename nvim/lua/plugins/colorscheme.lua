local options = require("options")
local status = pcall(require, options.colorscheme)
if not status then
  vim.notify("Can't find colorscheme '" .. options.colorscheme .. "'!", vim.log.levels.WARN)
else
  vim.cmd("colorscheme " .. options.colorscheme)
end
