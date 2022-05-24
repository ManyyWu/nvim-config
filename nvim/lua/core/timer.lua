local M = { }

local global = require("global")
local uv = vim.loop

function M.set_timeout(timeout, callback, params)
  local timer = uv.new_timer()

  timer:start(timeout, 0, vim.schedule_wrap(function() -- vim.schedule_wrap保证在安全时调用回调
    timer:stop()
    timer:close()
    callback(params)
  end))

  return timer
end

function M.set_timer(timerout, interval, callback, params)
  local timer = uv.new_timer()

  timer:start(timeout, interval, vim.schedule_wrap(function()
    timer:stop()
    timer:close()
    callback(params)
  end))

  return timer
end

function M.close_timer(timer)
  timer:stop()
  timer:close()
end

return M
