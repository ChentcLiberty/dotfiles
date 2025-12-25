" =========================
" 基础设置（IC工程师必备）
" =========================
set nocompatible
syntax on
filetype plugin indent on

set number
set relativenumber
set cursorline
set ruler
set showcmd

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

set backspace=indent,eol,start
set nowrap
set hlsearch
set incsearch
set ignorecase
set smartcase

" 鼠标关闭（右键粘贴友好）
set mouse=

" 剪贴板
if has('clipboard')
  set clipboard=unnamedplus
endif

" F2 切换粘贴模式
set pastetoggle=<F2>

set history=1000
set undofile
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo', 'p', 0700)
endif
set undodir=~/.vim/undo//

" =========================
" 显示相关
" =========================
set laststatus=2
set statusline=%f\ %y\ %m%r%=%-14.(%l,%c%V%)\ %P

" =========================
" IC RTL/TB Enhancements
" =========================

" Prefer ripgrep for :grep (faster)
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m
endif

" Ignore common EDA artifacts in wildmenu/completion
set wildignore+=*.vcd,*.fsdb,*.wlf,*.sdf,*.spef,*.saif,*.svo,*.sva,*.rpt,*.out,*.d,*.o,*.obj,*.log
set wildignore+=INCA_libs/*,xcelium.d/*,verdiLog/*,simv*,csrc/*,work/*,sim/*

" =========================
" IC/EDA 文件类型 & 优化
" =========================
augroup ic_filetypes
  autocmd!
  autocmd BufRead,BufNewFile *.v         setfiletype verilog
  autocmd BufRead,BufNewFile *.sv,*.svh  setfiletype systemverilog
  autocmd BufRead,BufNewFile *.tcl       setfiletype tcl
  autocmd BufRead,BufNewFile *.log       setlocal nowrap noswapfile buftype=nowrite
augroup END

" Big logs perf
augroup ic_log_perf_more
  autocmd!
  autocmd BufReadPost *.log setlocal synmaxcol=200
augroup END

" Enable matchit for % pair jumps
if has('packages')
  packadd! matchit
else
  silent! runtime macros/matchit.vim
endif

" =========================
" HDL local settings and tools
" =========================
augroup ic_hdl
  autocmd!
  " Style + behavior
  autocmd FileType verilog,systemverilog setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType verilog,systemverilog setlocal textwidth=100 colorcolumn=100
  autocmd FileType verilog,systemverilog setlocal commentstring=//\ %s
  autocmd FileType verilog,systemverilog setlocal foldmethod=indent foldlevel=99
  autocmd FileType verilog,systemverilog setlocal iskeyword+=\$,\#
  autocmd FileType systemverilog         setlocal iskeyword+=\[
  autocmd FileType verilog,systemverilog setlocal suffixesadd+=.sv,.svh,.vh,.v

  " matchit pairs for HDL
  autocmd FileType verilog,systemverilog let b:match_words =
        \ '\<begin\>:\<end\>,' .
        \ '\<case\>:\<endcase\>,' .
        \ '\<casex\>:\<endcase\>,' .
        \ '\<casez\>:\<endcase\>,' .
        \ '\<module\>:\<endmodule\>,' .
        \ '\<macromodule\>:\<endmodule\>,' .
        \ '\<primitive\>:\<endprimitive\>,' .
        \ '\<interface\>:\<endinterface\>,' .
        \ '\<package\>:\<endpackage\>,' .
        \ '\<class\>:\<endclass\>,' .
        \ '\<task\>:\<endtask\>,' .
        \ '\<function\>:\<endfunction\>,' .
        \ '\<generate\>:\<endgenerate\>,' .
        \ '\<specify\>:\<endspecify\>,' .
        \ '\<fork\>:\<join\>\|\<join_any\>\|\<join_none\>'

  " Verible formatter (detected)
  autocmd FileType verilog,systemverilog if executable('verible-verilog-format') |
        \   setlocal formatprg=verible-verilog-format\ --column_limit=100\ --indentation_spaces=4 |
        \   nnoremap <buffer> <leader>f :silent %!verible-verilog-format\ --column_limit=100\ --indentation_spaces=4<CR> |
        \ endif

  " Verilator lint (optional; detected)
  autocmd FileType verilog,systemverilog if executable('verilator') |
        \   setlocal makeprg=verilator\ --lint-only\ -Wall\ % |
        \   setlocal errorformat=%f:%l:%c:%t%*[^:]:\ %m |
        \   nnoremap <buffer> <leader>m :make<CR> |
        \ endif

  " Review navigation
  autocmd FileType verilog,systemverilog nnoremap <buffer> ]m /\v^\s*(module\|interface\|package)\>/<CR>
  autocmd FileType verilog,systemverilog nnoremap <buffer> [m ?\v^\s*(module\|interface\|package)\>?<CR>
  autocmd FileType verilog,systemverilog nnoremap <buffer> ]t /\v^\s*(task\|function\|class)\>/<CR>
  autocmd FileType verilog,systemverilog nnoremap <buffer> [t ?\v^\s*(task\|function\|class)\>?<CR>
  autocmd FileType verilog,systemverilog nnoremap <buffer> ]c /\v^\s*(case\|casex\|casez)\>/<CR>
  autocmd FileType verilog,systemverilog nnoremap <buffer> [c ?\v^\s*(case\|casex\|casez)\>?<CR>

  " Toggle multi-window synchronous edit (scroll+cursor bind)
  autocmd FileType verilog,systemverilog nnoremap <buffer> <leader>ss :set scb! crb!<CR>

  " Precise whole-word search starter
  autocmd FileType verilog,systemverilog nnoremap <buffer> <leader>/ /\v<><Left>
augroup END

" =========================
" VCS logs → quickfix
" =========================
function! s:SetEfmVCS() abort
  let efm = ''
  let efm .= '%E%f:%l:\ %trror:\ %m,'
  let efm .= '%W%f:%l:\ %tarning:\ %m,'
  let efm .= '%AError-%*[^\ ]:\ %m,'
  let efm .= '%CFile:\ %f,\ line\ %l%*,'
  let efm .= '%Z%.%#,'
  let efm .= '%AWarning-%*[^\ ]:\ %m,'
  let efm .= '%CFile:\ %f,\ line\ %l%*,'
  let efm .= '%Z%.%#,'
  let efm .= '%-G%.%#'
  execute 'setlocal errorformat=' . efm
endfunction

augroup ic_vcs_log
  autocmd!
  autocmd FileType log nnoremap <buffer> <leader>gl :call <SID>SetEfmVCS()<Bar>setlocal makeprg=cat\ %<Bar>silent make<Bar>copen<CR>
  autocmd FileType log syntax match LogError /\c\<\(error\|fatal\|critical\|severe\)\>/
  autocmd FileType log syntax match LogWarn  /\c\<\(warn\|warning\)\>/
  autocmd FileType log hi def link LogError ErrorMsg
  autocmd FileType log hi def link LogWarn  WarningMsg
augroup END

" =========================
" Signal/Instance helpers (rg preferred)
" =========================
let g:ic_hdl_globs = get(g:, 'ic_hdl_globs', ['**/*.sv','**/*.svh','**/*.v','**/*.vh'])

function! s:GetRoot() abort
  return get(g:, 'ic_hdl_root', getcwd())
endfunction

function! s:GrepWith(pattern, open_qf) abort
  if executable('rg')
    let root = s:GetRoot()
    let args = ''
    for gpat in g:ic_hdl_globs | let args .= ' -g ' . shellescape(gpat) | endfor
    execute 'silent grep! -S ' . args . ' -e ' . shellescape(a:pattern) . ' ' . shellescape(root)
    if a:open_qf | botright copen | endif
  else
    execute 'silent vimgrep /' . escape(a:pattern, '/\') . '/gj ' . join(g:ic_hdl_globs, ' ')
    if a:open_qf | botright copen | endif
  endif
endfunction

function! s:SigDecl() abort
  let w = expand('<cword>')
  if empty(w) | return | endif
  let decl = '\v<(input|output|inout|wire|logic|reg|bit|parameter|localparam)>([^;]|\n)*<' . w . '>\b'
  call s:GrepWith(decl, v:true)
  if empty(getqflist()) | call s:GrepWith('\v<' . w . '>', v:true) | endif
  if !empty(getqflist()) | cfirst | normal! zz | endif
endfunction

function! s:SigRefs() abort
  let w = expand('<cword>')
  if empty(w) | return | endif
  call s:GrepWith('\v<' . w . '>', v:true)
  if !empty(getqflist()) | cfirst | normal! zz | endif
endfunction

function! s:Inst() abort
  let w = expand('<cword>')
  if empty(w) | return | endif
  let pat = '\v<' . w . '>\s*(#\s*\([^)]*\)\s*)?\s*\('
  call s:GrepWith(pat, v:true)
  if !empty(getqflist()) | cfirst | normal! zz | endif
endfunction

function! s:HasTags(name) abort
  return !empty(taglist('^' . a:name . '$'))
endfunction

function! s:GotoDef() abort
  let w = expand('<cword>')
  if empty(w) | return | endif
  if s:HasTags(w) | execute 'tjump ' . w | else | call s:SigDecl() | endif
endfunction

" =========================
" 快捷键（工程师高频）
" =========================
let mapleader=" "

" 保存 & 退出
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>

" 快速切换窗口
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" 快速分屏
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>

" 搜索高亮关闭
nnoremap <leader>n :nohlsearch<CR>

" Window helpers
nnoremap <leader>= :wincmd =<CR>
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +10<CR>
nnoremap <leader>< :vertical resize -10<CR>

" Signal/Instance mappings
nnoremap <leader>sd :call <SID>SigDecl()<CR>
nnoremap <leader>sr :call <SID>SigRefs()<CR>
nnoremap <leader>sN :cnext<CR>
nnoremap <leader>sP :cprev<CR>
nnoremap <leader>rd :call <SID>GotoDef()<CR>
nnoremap <leader>ri :call <SID>Inst()<CR>

