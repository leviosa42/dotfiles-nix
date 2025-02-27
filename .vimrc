" __   _(_)_ __ ___  _ __ ___  "
" \ \ / / | '_ ` _ \| '__/ __| "
"  \ V /| | | | | | | | | (__  "
" (_)_/ |_|_| |_| |_|_|  \___| "
"
" === pre init ===
scriptencoding utf-8
syntax off
filetype off
filetype indent plugin off

" === plugin manager(vim-jetpack) ===
" --- configuration for vim-jetpack ---
let g:jetpack_download_method = 'wget'
" --- automatic install if needed ---
let s:jetpackfile = expand('~/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim')
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
  " call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
  call mkdir(fnamemodify(s:jetpackfile, ':h'), 'p')
  call system(printf('wget -qO %s %s', s:jetpackfile, s:jetpackurl))
endif

" --- add plugins ---
packadd vim-jetpack
call jetpack#begin()
call jetpack#add('tani/vim-jetpack', {'opt': 1}) " bootstrap
call jetpack#add('vim-jp/vimdoc-ja') " help for japanese
call jetpack#add('tpope/vim-commentary') " comment in/out
call jetpack#add('markonm/traces.vim') " preview the replacement results
call jetpack#add('machakann/vim-highlightedyank') " flash yanked text
call jetpack#add('lambdalisue/vim-manpager') " manpager
call jetpack#add('leviosa42/kanagawa-mini.vim') " colorscheme
call jetpack#add('leviosa42/vim-github-theme') " colorscheme
call jetpack#add('tomasr/molokai') " colorscheme
call jetpack#add('morhetz/gruvbox') " colorscheme
call jetpack#add('altercation/vim-colors-solarized') " colorscheme
call jetpack#add('sainnhe/everforest') " colorscheme
call jetpack#add('ghifarit53/tokyonight-vim') " colorscheme
  let g:tokyonight_style = 'night'
call jetpack#add('catppuccin/vim', {'as': 'catppuccin'}) " colorscheme
call jetpack#add('cocopon/iceberg.vim') " colorscheme
call jetpack#end()

" :h man.vim
" ref: https://muru.dev/2015/08/28/vim-for-man.html
" runtime! ftplugin/man.vim
let g:ft_man_folding_enable = 1
let g:ft_man_no_sect_fallback = 1

" === configures ===
" --- backup ---
set backup
let s:backup_dirpath = expand('~/.vim/backup')
call mkdir(s:backup_dirpath, 'p')
execute 'set backupdir=' .. s:backup_dirpath

" --- swapfile ---
set swapfile
let s:swap_dirpath = expand('~/.vim/swap')
call mkdir(s:swap_dirpath, 'p')
execute 'set directory=' .. s:swap_dirpath

" --- undo ---
if has('persistent_undo')
  set undofile
  let s:undo_dirpath = expand('~/.vim/undo')
  call mkdir(s:undo_dirpath, 'p')
  execute 'set undodir=' .. s:undo_dirpath
endif

" --- colorscheme ---
if has('termguicolors')
  set termguicolors
endif
set background=dark
try
  " colorscheme iceberg
  " colorscheme molokai
  colorscheme tokyonight
catch
  colorscheme darkblue
endtry

set helplang=ja,en

set clipboard=

set title

set virtualedit=onemore

set hidden
set number
set cursorline

set showmatch
set showcmd

set whichwrap=b,s,<,>,[,]

set scrolloff=2

set modeline
set modelines=3

set keywordprg=:help

set mouse=a

" === indentation ===
set noexpandtab " et == use space
set smarttab
set tabstop=4
set shiftwidth=0 softtabstop=-1 " follow to tabstop
set autoindent
set smartindent

" === slash searching ===
set incsearch
set ignorecase
set smartcase
set hlsearch

" === listchars ===
set list
set listchars=
" set listchars+=tab:>\\x20
" set listchars+=tab:→\\x20
set listchars+=tab:›\\x20 " SINGLE RIGHT-POINTING ANGLE QUOTATION MARK(>1)
" set listchars+=lead:• " BULLET(oo)
set listchars+=lead:· " MIDDLE DOT(.M)
set listchars+=trail:~
set listchars+=extends:» " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK(>>)
set listchars+=precedes:« " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK(<<)

" === wildmenu ===
set wildmenu
set wildmode=list:longest,full

" === statusline ===
set laststatus=2
let s:stl = ''
" let s:stl .= '%-{%g:actual_curwin==win_getid(winnr())?"%#SignColumn#":"%#StatusLineNC#"%}'
let s:stl .= '%-{%g:actual_curwin==win_getid(winnr())?"%#Directory#":"%#StatusLineNC#"%}'
let s:stl .= ' %{mode()[0]} ' " mode
let s:stl .= '%-{%g:actual_curwin==win_getid(winnr())?&modified?"%#Diff#":"%#StatusLine#":"%#StatusLineNC#"%}'
let s:stl .= ' '
let s:stl .= '%-F' " filename
let s:stl .= '%-m' " is modified
let s:stl .= '%-r' " is readonly
let s:stl .= '%-h' " is help-page
let s:stl .= '%=' " separation point between left and right
let s:stl .= '%{%g:actual_curwin==win_getid(winnr())?"%#CursorLine#":"%#StatusLineNC#"%}'
" let s:stl .= ' '
" let s:stl .= '%y'
let s:stl .= ' '
let s:stl .= '%{&ft}'
let s:stl .= ' '
let s:stl .= '%{&et?"spc":"tab"}:%{&ts}'
let s:stl .= ' '
let s:stl .= '%{&fenc!=""?&fenc:&enc}'
let s:stl .= ' '
let s:stl .= '%{&ff=="dos"?"CRLF":&ff=="unix"?"LF":"CR"}' " show fileformat
let s:stl .= ' '
" let s:stl .= '%l,%c' " lines/columns
let s:stl .= '%p%%'
let s:stl .= ' '
let s:stl .= '%<'
let &statusline = s:stl

" === key mapping ===
let g:mapleader = "\<Space>"

inoremap <silent> jk <Esc>
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap U <C-r>
nnoremap <C-r> U
nnoremap x "_x
nnoremap <silent> <S-Up> "zdd<Up>"zP
nnoremap <silent> <S-Down> "zdd"zp
vnoremap <S-Up> "zx<Up>"zP`[V`]
vnoremap <S-Down> "zx"zp`[V`]
nnoremap <Leader>h :nohlsearch<CR>
" --- [buffer] ---
nmap <Leader>b [buffer]
nnoremap [buffer] <Nop>
nnoremap [buffer]n :new<CR>
nnoremap [buffer]j :bnext<CR>
nnoremap [buffer]k :bprevious<CR>
nnoremap [buffer]l :ls<CR>
" --- [vimrc] ---
nmap <Leader>v [vimrc]
nnoremap [vimrc]s :source $MYVIMRC<CR>
nnoremap [vimrc]e :edit $MYVIMRC<CR>
" --- terminal ---
nmap <Leader>x [terminal]
nnoremap [terminal]h :vertical aboveleft terminal<CR>
nnoremap [terminal]j :rightbelow terminal<CR>
nnoremap [terminal]k :aboveleft terminal<CR>
nnoremap [terminal]l :vertical rightbelow terminal<CR>
nnoremap [terminal]<Space> :terminal ++curwin<CR>
" --- window ---
nmap <Leader>w [window]
nnoremap [window] <C-w>
" === autocmds ===
" --- 'keywordprg' by filetype ---
augroup KeywordprgByFileType
  autocmd!
  autocmd FileType vim setl kp=:help
  autocmd FileType sh  setl kp=man
    \ | nnoremap K :Man <cword><CR>
augroup END

" --- indentation by filetype ---
augroup IndentationByFileType
  autocmd!
  autocmd FileType vim setl ts=2 noet
  autocmd FileType sh  setl ts=2 et
  autocmd FileType c   setl ts=4 noet cindent
  autocmd FileType man setl ts=4
augroup END

" --- 'makeprg' by filetype ---
augroup MakeprgByFileType
 autocmd!
 autocmd FileType c setl mp=gcc\ %
augroup END

" --- 'commentstring' by filetype ---
augroup CommentstringByFileType
  autocmd!
  autocmd FileType vim setl cms=\"\ %s
  autocmd FileType sh  setl cms=#\ %s
  autocmd FileType c   setl cms=//\ %s
augroup END

augroup Man
  autocmd!
  autocmd FileType man
    \ | setl nolist nonumber nomodifiable readonly noswapfile
    \ | if !empty($MAN_PN) | file $MAN_PN endif
augroup END

" === post init ===
syntax enable
filetype plugin indent on

" vim: set et ts=2 sw=0 sts=-1 fmr={{{,}}}:
