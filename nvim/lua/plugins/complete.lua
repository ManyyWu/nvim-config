local lspkind   = require("lspkind")
local luasnip   = require("luasnip")
local lspconfig = require("lspconfig")
local cmp       = require("cmp")

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup({
  -- snippet
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  -- 窗口
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  -- 快捷键
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    --["<Tab>"] = cmp.mapping(function(fallback)
    --end, {
    --  "i",
    --  "s",
    --}),
    --["<S-Tab>"] = cmp.mapping(function(fallback)
    --end, {
    --  "i",
    --  "s",
    --}),

    -- Esc???

    --["<C-Space>"] = cmp.mapping.complete(),
    --["<C-e>"] = cmp.mapping.abort(),
    --["<CR>"] = cmp.mapping(function(fallback)
    --end),
    --https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#intellij-like-mapping
  },
  -- 来源
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer"   },
    { name = "path"     },
    { name = "cmdline"  },
    { name = "nvim_lua" },
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      before = function (entry, vim_item)
        -- 提示来源
        vim_item.menu = "[" .. entry.source.name .. "]"
        return vim_item
      end
    })
  },
})

cmp.setup.cmdline('/', {
  sources = { { name = 'buffer' } }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})
