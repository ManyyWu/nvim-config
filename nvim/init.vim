lua << EOF
if vim.fn.has "nvim-0.7" ~= 1 then
  vim.notify("Please upgrade your Neovim base installation. Lunarvim requires v0.7+", vim.log.levels.WARN)
  vim.wait(5000, function() return false end)
  vim.cmd "cquit"
end

require "init"
EOF
