local vim_options = {
  --[[ 编码 ]]--
  {
    -- fileencodings为编码自动识别列表，需要按严格=>宽松的顺序排列
    fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1",
  },

  --[[ 鼠标 ]]--
  {
    -- mouse="a":禁用鼠标右键，使用shift选择,
    {
      opts  = { mouse = "a", },
      cond  = function () return (1 == vim.fn.has("mouse")) end,
    },
  },

  --[[ 显示 ]]--
  {
    -- encoding为内部编码(buffer、寄存器、脚本中的字符串)，编码不一致时会转换为此编码
    encoding = "utf-8",

    -- 行号
    number = true,

    -- 相对行号
    --relativenumber = true,

    -- 缩进
    tabstop     = 2,    -- Tab显示空格数
    shiftwidth  = 2,    -- 自动缩进空格数
    softtabstop = -1,   -- Tab插入空格数，-1表示与shiftwidth保持一致，Backspace一次删除2个空格
    expandtab   = true, -- Tab替换空格

    -- 关闭模式提示
    showmode = false,

    -- 命令行高，防止显示Press ENTER or type command to continue
    cmdheight = 2,

    -- 高亮当前行
    cursorline = true,

    -- 始终显示符号栏
    signcolumn = "yes",
  },

  --[[ 搜索 ]]--
  {
    -- 不包含大写时大小写不敏感
    ignorecase = true,
    smartcase  = true,

    -- 高亮搜索结果
    hlsearch = true,

    -- 边输入边搜索
    incsearch = true,
  },

  --[[ 标签栏 ]]--
  {
    -- 始终显示标签栏
    showtabline = 2,
  },

  --[[ 滚动 ]]--
  {
    -- 滚动时保留行/列数
    scrolloff     = 8,
    sidescrolloff = 8,
  },

  --[[ buffer ]]--
  {
    -- 允许未保存时切换buffer
    hidden = true,
  },

  --[[ 自动 ]]--
  {
    -- 关闭自动换行
    wrap = false,

    -- 关闭自动备份
    backup      = false,
    writebackup = false,
    swapfile    = false,

    -- 持久撤销
    undofile = true,
  },

  --[[ 外观 ]]--
  {
    background    = "dark",
    termguicolors = true,
  },

  --[[ 补全 ]]--
  {
    -- 补全增强
    wildmenu = true,

    -- 自动补全不自动选中
    -- menu: 多于一项才显示菜单
    -- menuone: 即使只有一项也显示菜单
    -- noinsert: 不选择时不插入文本
    -- noselect: 强迫用户选择
    completeopt = "menu,menuone",
  },

  --[[ 剪切板 ]]--
  {
    -- 使用系统剪切板
    clipboard = "unnamedplus",
  },

  --[[ 窗口 ]]--
  {
    -- 在右侧和下方分割窗口
    splitbelow = true,
    splitright = true,
  },

  -- 折叠
  {
    -- 开启折叠，默认不折叠
    foldmethod = "expr",
    foldexpr   = "nvim_treesitter#foldexpr()",
    foldlevel  = 99,
  },
}

local cmds = {
  -- 自动读取
  {
    enable = true,
    cmd = [[
      set updatetime=3000
      set autoread

      augroup auto_read
      autocmd!
      autocmd CursorHold * checktime | call feedkeys("lh")
      augroup END
    ]]
  },

  -- nvim-tree为最后一个窗口时自动关闭nvim
  {
    enable = true,
    cmd = [[
      augroup auto_close_when_last
      autocmd!
      autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
      augroup END
    ]]
  },

  -- 显示空白字符
  --[[highlight TabSpaceColor guibg=#262626 ctermfg=darkgrey | match TabSpaceColor /\\t\\| /]]
}

for _, g in pairs(vim_options) do
  for i, v in pairs(g) do
    if type(v) == "table" then
      if v.cond and v.cond() then
        for ii, vv in pairs(v.opts) do
          vim.opt[ii] = vv
        end
      end
    else
      vim.opt[i] = v
    end
  end
end

for _, v in pairs(cmds) do
  if v.enable then
    vim.cmd(v.cmd)
  end
end
