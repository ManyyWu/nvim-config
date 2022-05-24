local M = { }

local uv = vim.loop

function M.is_dir(path)
  local stat = uv.fs_stat(path)

  return (nil ~= stat and stat.type == "directory")
end

function M.is_file(path)
  local stat = uv.fs_stat(path)

  return (nil ~= stat and stat.type == "file")
end

return M
