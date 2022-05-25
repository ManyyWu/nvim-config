local global = require("global")
local opts = { noremap = true, silent = true }
local opts = { noremap = true, silent = true }
local set = vim.keymap.set
local unset = vim.keymap.del
local config_path = global.config_path

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd([[
func! DeleteCurBufferNotCloseWindow() abort
  if &modified
    echohl ErrorMsg
    echom "E89: no write since last change"
    echohl None
  elseif winnr('$') == 1
    bd
  else              " multiple window
    let oldbuf = bufnr('%')
    let oldwin = winnr()
    while 1         " all windows that display oldbuf will remain open
      if buflisted(bufnr('#'))
        b#
      else
        bn
        let curbuf = bufnr('%')
        if curbuf == oldbuf
            enew    " oldbuf is the only buffer, create one
        endif
      endif
      let win = bufwinnr(oldbuf)
      if win == -1
        break
      else          " there are other window that display oldbuf
        exec win 'wincmd w'
      endif
    endwhile
    " delete oldbuf and restore window to oldwin
    exec oldbuf 'bd'
    exec oldwin 'wincmd w'
  endif
endfunc

function! MarkWindowSwap()
  unlet! g:markedWin1
  unlet! g:markedWin2
  let g:markedWin1 = winnr()
endfunction

function! DoWindowSwap()
  if exists('g:markedWin1')
    if !exists('g:markedWin2')
        let g:markedWin2 = winnr()
    endif
    let l:curWin = winnr()
    let l:bufWin1 = winbufnr(g:markedWin1)
    let l:bufWin2 = winbufnr(g:markedWin2)
    exec g:markedWin2 . 'wincmd w'
    exec ':b '.l:bufWin1
    exec g:markedWin1 . 'wincmd w'
    exec ':b '.l:bufWin2
    exec l:curWin . 'wincmd w'
  endif
endfunction
]])

-- Mode
-- ""   mapmode-nvo	Normal, Visual, Select, Operator-pending	:map
-- "n"	mapmode-n	  Normal	                                  :nmap
-- "v"	mapmode-v	  Visual and Select	                        :vmap
-- "s"	mapmode-s	  Select	                                  :smap
-- "x"	mapmode-x	  Visual	                                  :xmap
-- "o"	mapmode-o	  Operator-pending	                        :omap
-- "!"	mapmode-ic	Insert and Command-line	                  :map!
-- "i"	mapmode-i	  Insert	                                  :imap
-- "l"	mapmode-l	  Insert, Command-line, Lang-Arg	          :lmap
-- "c"	mapmode-c	  Command-line	                            :cmap
-- "t"	mapmode-t	  Terminal	                                :tmap

--[[ Ctrl/Alt组合键 ]]--
-- <Esc>代替<C-c>(<C-c>不会触发InsertLeave事件，会影响nvim-spectre刷新)
set("i", "<C-c>",      "<Esc>", opts)
-- 窗口(可使用鼠标拖动)
set("n", "<C-h>",      "<C-w>h", opts) -- 需要终端设置C-h发送^?
set("n", "<C-j>",      "<C-w>j", opts)
set("n", "<C-k>",      "<C-w>k", opts)
set("n", "<C-l>",      "<C-w>l", opts)
set("n", "<C-q>",      ":q<CR>", opts)
set("n", "<A-q>",      ":q<CR>", opts)
set("n", "<A-k>",      ":resize -5<CR>", opts)
set("n", "<A-j>",      ":resize +5<CR>", opts)
set("n", "<A-h>",      ":vertical resize -5<CR>", opts)
set("n", "<A-l>",      ":vertical resize +5<CR>", opts)
set("n", "<A-v>",      ":vsp<CR>", opts)
set("n", "<A-s>",      ":sp<CR>", opts)
-- buffer
set("n", "<A-n>",      ":bn<CR>", opts)
set("n", "<A-p>",      ":bp<CR>", opts)
set("n", "<A-c>",      ":call DeleteCurBufferNotCloseWindow()<CR>", opts)

local M = { }

M.opts = opts

M.leader_keybinding = {
  -- 交换窗口
  h = { ":call MarkWindowSwap()<CR> <C-w>h :call DoWindowSwap()<CR> <C-w>l", "Swap Left" },
  j = { ":call MarkWindowSwap()<CR> <C-w>j :call DoWindowSwap()<CR> <C-w>k", "Swap Down" },
  k = { ":call MarkWindowSwap()<CR> <C-w>k :call DoWindowSwap()<CR> <C-w>j", "Swap Up" },
  l = { ":call MarkWindowSwap()<CR> <C-w>l :call DoWindowSwap()<CR> <C-w>h", "Swap Right" },
  -- 其他
  o = {
    name = "Others",
    r = { ":lua require('core.reload').reload_all_config(true)<CR>", "Reload Neovim Config" },
    c = { ":lua require('telescope.builtin').colorscheme()<CR>", "Select Colortheme" },
    t = { ":TSModuleInfo<CR>", "TreeSitter Install Info" },
    l = {
      name = "Lsp Info",
      i = { ":LspInstallInfo<CR>", "Lsp Install Info" },
      s = { ":LspInfo<CR>", "Lsp Info" },
    },
  },
}

M.leader2_keybinding = {
  -- 文件树
  e = { ":NvimTreeToggle<CR>", "File Explorer", },
  -- 列举引用
  r = { ":lua require('telescope.builtin').lsp_references()<CR>", "Symbol References" },
  -- 列举符号
  s = {
    name = "Symbols",
    a = { ":lua require('telescope.builtin').lsp_workspace_symbols()<CR>", "All Symbols" },
    f = { ":lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>", "Dynamic Symbols" },
  },
  -- 搜索
  f = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Replace" },
  r = { ":lua require('telescope.builtin').resume()<CR>", "Resume Search Panel"},
  -- 帮助
  h = { ":!cat " .. config_path .. "/lua/help.txt<CR>", "Help" },
  s = {
    name = "Search",
    s = { ":lua require('telescope.builtin').grep_string()<CR>", "Search Current Word(fuzzy)" },
    g = { ":lua require('telescope.builtin').live_grep()<CR>", "Live Search(regex)" },
    z = { ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", "Fuzzy Search In Buffer(fuzzy)" },
    f = { ":lua require('telescope.builtin').find_files()<CR>", "Find File(fuzzy)" },
    b = { ":lua require('telescope.builtin').buffers()<CR>", "Find Buffer" },
    h = { ":lua require('telescope.builtin').help_tags()<CR>", "Find Help" },
    o = { ":lua require('telescope.builtin').oldfiles()<CR>", "Find OldFiles" },
    t = { ":lua require('telescope.builtin').diagnostics()<CR>", "Diagnostics" },
  },
  -- git
  g = {
    name = "Git",
    g = { ":lua require('toggleterm').exec(require('global').config_path .. '/bin/lazygit')<CR>", "Lazygit" },
    d = { ":lua require('telescope.builtin').git_status()<CR>", "Diff" },
    b = { ":lua require('telescope.builtin').git_branches()<CR>", "Branches" },
    c = { ":lua require('telescope.builtin').git_commits()<CR>", "Log" },
    s = { ":lua require('telescope.builtin').git_stash()<CR>", "Stash" },
    v = { ":lua require('telescope.builtin').git_bcommits()<CR>", "Log For Current File" },
  },
}

-- lsp快捷键设置
function M.set_lsp_keymaps(bufnr)
  local set = vim.api.nvim_buf_set_keymap

  set(bufnr, 'n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)            -- 跳转定义
  set(bufnr, 'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)           -- 跳转声明
  set(bufnr, 'n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)        -- 跳转实现
  set(bufnr, 'n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)            -- 跳转引用
  set(bufnr, 'n', 'gh', ':lua vim.lsp.buf.hover()<CR>', opts)                 -- 文档
  set(bufnr, 'n', 'gb', ':lua vim.lsp.buf.document_symbol()<CR>', opts)       -- 符号

  -- 诊断
  set(bufnr, 'n', 'go', ':lua vim.diagnostic.open_float()<CR>', opts)         -- 显示诊断提示
  set(bufnr, 'n', 'gp', ':lua vim.diagnostic.goto_prev()<CR>', opts)          -- 跳转到下一个诊断提示
  set(bufnr, 'n', 'gn', ':lua vim.diagnostic.goto_next()<CR>', opts)          -- 跳转到下一个诊断提示

  set(bufnr, 'n', '<leader>ca', ':lua vim.lsp.buf.code_action()<CR>', opts)
  --set(bufnr, 'n', '<leader>f',  ':lua vim.lsp.buf.formatting()<CR>', opts)

  --vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- terminal
function M.set_terminal_keymaps()
  vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
end

return M
