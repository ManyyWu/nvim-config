local M = { }

local global = require("global")

function M.auto_reload_config()
  local config_path = global.config_path
  local pathfile = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")
  local filename = vim.fn.expand("%:t")
  local is_config_path = (vim.fn.matchstr(pathfile, config_path) == config_path)

  if is_config_path and ext == "lua" then
    dofile(pathfile)
    if filename == "plugins.lua" then
      vim.cmd("PackerSync")
    else
      vim.notify(pathfile .. " reload complete.", vim.log.levels.INFO)
    end
  end
end

function M.reload_all_config()
  local config_path = global.config_path

  dofile(config_path .. "/lua/init.lua")
  vim.notify("Reload all configuration complete.", vim.log.levels.INFO)
  vim.cmd("PackerSync")
end

return M
