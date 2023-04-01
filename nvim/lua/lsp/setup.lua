-- 确保先加载nvim-lsp-installer
local installer = require("nvim-lsp-installer")
installer.setup({
  ensure_installed = {              -- 预安装服务器
    --"sumneko_lua",
    --"bashls",

    -- 服务器列表(https://github.com/williamboman/nvim-lsp-installer#available-lsps)
  },
  automatic_installation = true,    -- lspconfig.lang.setup时自动安装语言服务器
  log_level = vim.log.levels.DEBUG, -- 日志级别
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

local function lsp_highlight_document(client)
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- 使用cmp_nvim_lsp代替Neovim自带的capabilities(不支持某些功能，比如代码段完成)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 为所有安装的服务器注册处理函数
local installed = require("nvim-lsp-installer").get_installed_servers()
local lspconfig = require("lspconfig")
for _, v in pairs(installed) do
  local opts = {}
  local status, custom_opts = pcall(require, "lsp.languages." .. v.name)
  if status then
    opts = custom_opts
  end

  opts.on_attach = function(client, bufnr)
    local have_config = pcall(require, "lsp.languages." .. v.name)
    local warnstr = ""
    if not have_config then
      warnstr = "(No configuration for " .. v.name .. " found, default configuration will be used)"
    end
    vim.notify(client.name .. " attached to " .. vim.inspect(client.config.cmd_cwd) .. "." .. warnstr, warnstr == "" and vim.log.levels.INFO or vim.log.levels.WARN)

    require("keymaps").set_lsp_keymaps(bufnr)

    lsp_highlight_document(client)

    require("lsp_signature").on_attach()
  end

  opts.capabilities = capabilities

  -- 合并自定义设置和默认设置
  opts = vim.tbl_deep_extend("force", v:get_default_options(), opts)
  -- 初始化
  lspconfig[v.name].setup(opts)
end

(function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false,    -- 行尾是否显示诊断提示
    signs = {
      active = {
      },
    },
    update_in_insert = true, -- 插入模式下显示诊断提示，set signcolumn=yes防止频繁显示/隐藏
    underline = true,        -- 下划线
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end)()

-- 诊断样式定制 https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
-- tami5/lspsaga.nvim - 基于 Neovim 内置 lsp 的轻量级 lsp 插件，具有高性能 UI
-- vim lua库不能跳转
