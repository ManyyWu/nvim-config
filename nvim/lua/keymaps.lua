local global = require("global")
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

--[[ leader组合键 ]]--
-- 切换文件树
set("n", "<leader>e",  ":NvimTreeToggle<CR>", opts)
-- 交换窗口
set("n", "<leader>k",  ":call MarkWindowSwap()<CR> <C-w>k :call DoWindowSwap()<CR> <C-w>j", opts)
set("n", "<leader>j",  ":call MarkWindowSwap()<CR> <C-w>j :call DoWindowSwap()<CR> <C-w>k", opts)
set("n", "<leader>l",  ":call MarkWindowSwap()<CR> <C-w>l :call DoWindowSwap()<CR> <C-w>h", opts)
set("n", "<leader>h",  ":call MarkWindowSwap()<CR> <C-w>h :call DoWindowSwap()<CR> <C-w>l", opts)
-- 搜索
set("n", "<leader>f",  "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", opts)
set("n", "<leader>r",  ":lua require('telescope.builtin').resume()<CR>", opts)
set("n", "<leader>ss", ":lua require('telescope.builtin').grep_string()<CR>", opts)
set("n", "<leader>sg", ":lua require('telescope.builtin').live_grep()<CR>", opts)
set("n", "<leader>sz", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", opts)
set("n", "<leader>sf", ":lua require('telescope.builtin').find_files()<CR>", opts)
set("n", "<leader>sb", ":lua require('telescope.builtin').buffers()<CR>", opts)
set("n", "<leader>sh", ":lua require('telescope.builtin').help_tags()<CR>", opts)
-- git
set("n", "<leader>gd", ":lua require('telescope.builtin').git_status()<CR>", opts)
set("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<CR>", opts)
set("n", "<leader>gc", ":lua require('telescope.builtin').git_commits()<CR>", opts)
set("n", "<leader>gs", ":lua require('telescope.builtin').git_stash()<CR>", opts)
set("n", "<leader>gv", ":lua require('telescope.builtin').git_bcommits()<CR>", opts)

--[[ ;单词 ]]--
-- lsp
set("n", ";l",         ":LspInstallInfo<CR>", opts)
set("n", ";li",        ":LspInfo<CR>", opts)
set("n", ";ts",        ":TSModuleInfo<CR>", opts)
-- 列举当前buffer诊断信息
set("n", ";sign",      ":lua require('telescope.builtin').diagnostics()<CR>", opts)
-- 列举引用
set("n", ";ref",       ":lua require('telescope.builtin').lsp_references()<CR>", opts)
-- 列举符号
set("n", ";symble",    ":lua require('telescope.builtin').lsp_workspace_symbols()<CR>", opts)
set("n", ";symble",    ":lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>", opts)
-- 显示帮
set("n", ";h",         ":!cat " .. config_path .. "/lua/help.txt<CR>", opts)
-- reload
set("n", ";reload",    ":lua require('core.reload').reload_all_config()<CR>", opts)
-- 最近打开的文件
set("n", ";recent",    ":lua require('telescope.builtin').oldfiles()<CR>", opts)
-- 切换主题
set("n", ";theme",     ":lua require('telescope.builtin').colorscheme()<CR>", opts)


local M = { }

M.opts = opts

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

return M
