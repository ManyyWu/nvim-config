local global = require("global")
local file = require("core.file")

--[[ packer ]]--
-- 自动安装
local packer_path = global.data_path .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = nil
if not file.is_dir(vim.fn.glob(packer_path)) then
  packer_bootstrap = vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path })
  --vim.notify("Installing packer...", vim.log.levels.INFO)
  vim.cmd("packadd packer.nvim")
end

local status, packer = pcall(require, "packer")
if not status then
  vim.notify("Packer is not installed!", vim.log.levels.WARN)
end

-- 加载插件
--[[
参考https://github.com/wbthomason/packer.nvim
use {
  "myusername/example",         -- 插件位置字符串

  -- 可选项
  disable = boolean,                                       -- 禁用
  as = string,                                             -- 安装插件
  installer = function,                                    -- 自定义安装程序
  updater =  function,                                     -- 自定义更新程序
  after = string or list,                                  -- 前置插件
  rtp = string,                                            -- 指定插件的子目录添加到 runtimepath
  opt = boolean,                                           -- 手动将插件标记为可选。
  branch = string,                                         -- 指定git分支
  tag = string,                                            -- 指定git标签
  commit = string,                                         -- 指定commit
  lock = boolean,                                          -- 不更新/同步，但会clean
  run = string, function, or table,                        -- Post-update/install hook
  requires = string or list,                               -- 插件依赖项
  rocks = string or list,                                  -- 为插件指定Luarocks依赖项
  config = string or function,                             -- 指定加载此插件后要运行的代码

  -- setup意味着opt = true
  setup = string或 function,                               -- 指定在加载此插件之前要运行的代码

  -- 以下都暗示延迟加载并暗示opt = true
  cmd = string或list,                                      -- 指定加载此插件的命令。可以是autocmd模式
  ft = string or list,                                     -- 指定加载这个插件的文件类型
  keys = string or list,                                   -- 指定加载此插件的地图。请参阅“键绑定”
  event = string or list,                                  -- 指定加载这个插件的自动命令事件
  fn = string or list                                      -- 指定加载此插件的函数
  cond = string, function, or list of strings / functions，-- 指定条件
  module = string or list                                  -- 为require指定Lua模块名称。当需要以这些模块名称之一开头的字符串时，将加载插件
  module_pattern = string or list                          -- 为require指定Lua模块名称的Lua模式
}
]]--
packer.startup({
  function()
    -- packer
    use("wbthomason/packer.nvim")

    -- 异步库
    use("nvim-lua/plenary.nvim")

    -- 菜单
    use("nvim-lua/popup.nvim")

    -- 主题(必须是ts支持的主题https://github.com/nvim-treesitter/nvim-treesitter/wiki/Colorschemes)
    use({
      "tanvirtin/monokai.nvim",
      config = "require('plugins.colorscheme')",
    })

    -- 自动保存
    use({
      "Pocco81/AutoSave.nvim",
      config = "require('autosave').setup({ opts = { debounce_delay = 1000 }})",
    })

    -- 状态栏
    use({
      "nvim-lualine/lualine.nvim",
      config = "require('lualine').setup({ options = { theme = 'ayu_dark' } })",
      requires = {
        "kyazdani42/nvim-web-devicons"
      },
    })

    -- 光标处单词高亮
    use("xiyaowong/nvim-cursorword")

    -- 高亮
    use({
      "nvim-treesitter/nvim-treesitter",
      config = "require('plugins.nvim-treesitter')",
      run = ":TSUpdate",
    })

    -- 自动括号完成
    use({
      "windwp/nvim-autopairs",
      config = "require('plugins.nvim-autopairs')",
    })

    -- 搜索(依赖ripgrep命令)
    use {
      "nvim-telescope/telescope.nvim",
      config = "require('plugins.telescope')",
    }

    -- 搜索及替换(依赖ripgrep和sed命令，macOS依赖repgrep和gnu-sed命令)
    use {
      "nvim-pack/nvim-spectre",
      config = "require('plugins.nvim-spectre')",
    }

    -- 文件树
    use({
      "kyazdani42/nvim-tree.lua",
      config = "require('plugins.nvim-tree')",
      requires = {
        "kyazdani42/nvim-web-devicons",             -- 图标
        "RRethy/nvim-treesitter-endwise",           -- end自动完成
      },
    })

    -- 标签栏
    use({
      "akinsho/bufferline.nvim",
      config = "require('plugins.bufferline')",
      requires = "kyazdani42/nvim-web-devicons",
    })

    -- lsp
    use({
      "neovim/nvim-lspconfig",                      -- lsp配置集合
      config = "require('lsp.setup')",
      requires = {
        "williamboman/nvim-lsp-installer",          -- lsp语言服务器安装器
      },
    })

    -- 补全
    use({
      "hrsh7th/nvim-cmp",                           -- 插件本体
      config = "require('plugins.complete')",
      requires = {
        "hrsh7th/cmp-nvim-lsp",                     -- lsp客户端
        "hrsh7th/cmp-buffer",                       -- 缓存
        "hrsh7th/cmp-path",                         -- 路径
        "hrsh7th/cmp-cmdline",                      -- 命令行
        "hrsh7th/cmp-nvim-lua",                     -- Neovim lua API
        "L3MON4D3/luasnip",                         -- 代码段
        "rafamadriz/friendly-snippets",             -- 常用语言的代码段
        "onsails/lspkind-nvim",                     -- 图标支持
        "ray-x/lsp_signature.nvim",                 -- 自动函数签名提示
      },
    })

    -- 终端
    use({
      "akinsho/toggleterm.nvim", tag = 'v2.*',
      config = "require('plugins.toggleterm')",
    })

    -- 按键绑定
    use({
      "folke/which-key.nvim",
      config = "require('plugins.which-key')"
    })

    -- 修改位置恢复
    use({
      "ethanholz/nvim-lastplace",
      config = "require('plugins.lastplace')",
    })

    -- clone后配置packer
    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    -- 弹窗提示
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end
    },
  }
})
