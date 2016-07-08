" Identify the directory that vimrc resides in (For compatibility with both *nix and windows)
let g:vimfiles = expand('<sfile>:p:h')

" Load common settings
execute 'source ' . g:vimfiles . '/vimrc'


" Neovim specific settings
