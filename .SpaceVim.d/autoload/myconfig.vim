function! myconfig#before() abort
  set rtp+=~/projects/vim-nim
endfunction

function! myconfig#after() abort
  echo "Hello there"
  set incsearch
  set ignorecase smartcase "Ignore case unless pattern includes capitals
  nnoremap <leader>h :set hlsearch! hlsearch?<CR>
  nnoremap <leader>s :%s/
  nnoremap <leader>w :%s/\s\+$//g<CR>
  nnoremap <leader>cs :let @/ = "" <bar> echo "search cleared" <CR>

  inoreabbrev sadface ʘ︵ʘ
endfunction
