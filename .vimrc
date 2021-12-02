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
nnoremap <leader>h :set hlsearch! hlsearch?<CR>
nnoremap <leader>t :e ~/todo<CR>
nnoremap <leader>s :%s/
nnoremap <leader>w :%s/\s\+$//g<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>cs :let @/ = "" <bar> echo "search cleared" <CR>
nnoremap <F2> :bprev<CR>
nnoremap <F3> :bnext<CR>
let @p = "f,lr\<CR>" "Move next function parameter to new line

"Typo helper
command! Wq wq

"Abbreviations
inoreabbrev sadface ʘ︵ʘ

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
call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb' " Github extensions for vim-fugitive
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'sheerun/vim-polyglot'
Plug 'ajmwagar/vim-deus'
Plug 'sainnhe/sonokai'
call plug#end()

silent! colo ron
silent! colo sonokai
silent! colo deus

" ctermfg and bg are both set to 10 by default, making the text unreadable.
if g:colors_name == 'deus'
    hi StatusLine ctermbg=2 ctermfg=7 cterm=bold guibg=NONE guifg=NONE gui=NONE
    hi StatusLineNC ctermbg=8 ctermfg=7 cterm=bold guibg=NONE guifg=NONE gui=NONE
endif

nnoremap gd :ALEGoToDefinition<CR>
