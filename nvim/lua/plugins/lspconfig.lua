local lspconfig = require("lspconfig")

local cfg = {
  ensure_installed = {           -- 预安装语言服务器
    "sumneko_lua",
    "bashls",
  },
  automatic_installation = true, -- 自动检测并安装语言服务器
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
}

lspconfig.sumneko_lua.setup(cfg)
