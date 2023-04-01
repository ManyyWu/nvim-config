local M = { }

local utils = require("core.utils")

M.config_path = vim.fn.stdpath("config")
M.data_path = vim.fn.stdpath("data")
M.cache_path = vim.fn.stdpath("cache")
M.bin_path = M.config_path .. "/bin"

return utils.create_read_only_table(M)
