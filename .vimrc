inoremap jk <ESC>
let mapleader = " "
set nocompatible
syntax on
set wildmenu
filetype plugin indent on
set incsearch

set termguicolors

set hlsearch
set number relativenumber
set lazyredraw

"Indentation
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent
set autoindent

set hidden " Allow changing buffer without saving
set ignorecase smartcase "Ignore case unless pattern includes capitals
set splitbelow splitright

"Pane movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Shortcuts
nnoremap <leader>b :ls<CR>:buffer<Space>
nnoremap <leader>t :e ~/todo<CR>
nnoremap <leader>h :set hlsearch! hlsearch?<CR>
nnoremap <leader>s :%s/
nnoremap <leader>w :%s/\s\+$//g<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>cs :let @/ = "" <bar> echo "search cleared" <CR>
nnoremap <F2> :bprev<CR>
nnoremap <F3> :bnext<CR>
nnoremap <leader>gb :Grepper-buffers<CR>
nnoremap <leader>gg :Grepper<CR>
nnoremap <leader>ff :FZF<CR>
nnoremap <leader>nt :NERDTreeFocus<CR>
let @p = "f,lr\<CR>" "Move next function parameter to new line

"Typo helper
command! Wq wq

"Abbreviations
inoreabbrev .sad. ʘ︵ʘ
inoreabbrev .shrug. -\_( )_/-

"Paste block into terminal repl. Only works with a single split, and keeps
"indentation so sometimes annoying for python, but simple
vnoremap <leader>p "ry<c-w>w<c-w>"r<c-w>w

function! Scratch()
    vsplit
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    lcd ~
    file scratch
endfunction
nnoremap <leader>z :call Scratch()<CR>

autocmd! BufWritePost $MYVIMRC source $MYVIMRC

" Plugins
" Install vim-plug if it isn't already installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb' " Github extensions for vim-fugitive
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'ajmwagar/vim-deus'
Plug 'sainnhe/sonokai'
Plug 'junegunn/fzf', { 'on': ['FZF', 'Files'] }
Plug 'junegunn/fzf.vim', { 'on': ['FZF', 'Files', 'Maps', 'Lines'] }
Plug 'mhinz/vim-grepper', { 'on': 'Grepper' }
Plug '~/projects/vim-nim', { 'for': 'nim' }
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFocus'] }
Plug 'elixir-editors/vim-elixir'
call plug#end()

" Start NERDTree on startup and put the cursor back in the other window.
" Disabled because I don't use it all that much, and loading NERDTree on
" windows is slow.
" autocmd VimEnter * NERDTree | wincmd p

let NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1
let NERDTreeWinSize=25

let g:grepper = { 'tools': ['rg', 'git', 'grep'] }

let g:nvim_nim_exec_nimsuggest='nimsuggest'

silent! colo ron
silent! colo deus
silent! colo sonokai
