local lspconfig = require("lspconfig")

local cfg = {
  ensure_installed = {           -- 预安装语言服务器
    --"lua_ls",
    "clangd",
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
