return {
  -- 中文提示
  cmd = {"lua-language-server", "--locale=zh-cn"},

  -- 服务器工作范围
  root_dir = function()
      return vim.fn.getcwd()
  end,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        -- 不询问使用3rd配置
        checkThirdParty = false,
        -- 库路径
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false
      }
    }
  }
}
