local status, proj_spec_cfg = pcall(require, "custom_projects")

local project_specific_config = vim.api.nvim_create_augroup("project_specific_config", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  pattern = { "*" },
  callback = function()
    if not status then
      return
    end

    local pathfile = vim.fn.getcwd()
    for i, v in pairs(proj_spec_cfg) do
      local is_same_path = (vim.fn.matchstr(pathfile, i) == i)
      if is_same_path then
        require(v)
        break
      end
    end
  end,
  group = project_specific_config,
})


