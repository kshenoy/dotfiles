""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RE-MAPPING FOR CONVENIENCE                                                                                        {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Redirect F1 to list of all commands which is more useful than the default help page
noremap <F1> :vert bo h index<CR>

""" Remap w to behave as 'w' should in all cases (:h cw). Use ce to do what 'cw' used to
nnoremap cw dwi
nnoremap cW dWi

""" Show full file path while opening file
cabbrev %p%  <C-R>=fnameescape(expand('%:p'))<CR>
cabbrev %ph% <C-R>=fnameescape(expand('%:p:h'))<CR>
cabbrev %pt% <C-R>=fnameescape(expand('%:p:t'))<CR>
cabbrev %pr% <C-R>=fnameescape(expand('%:p:r'))<CR>

""" Display full path and filename
nnoremap <C-G> 2<C-G>

""" Copy the file name to unix visual select buffer
nnoremap <expr> y<C-G> ':let @' . (has('win_32') ? '+' : '*') . '="' . expand("%:p") . '"<CR>'

""" Open help in a vertically split window. Use `:set splitright` to open on the right
cnoreabbrev <expr> h ((getcmdtype() == ':' && getcmdline() ==# 'h') ? 'vert bo h' : 'h')

""" Make Y consistent with C and D
nnoremap Y y$

""" Break undo-sequence before deleting till start of line
inoremap <C-U> <C-G>u<C-U>

""" Remap ZQ to quit everything. I can always use :bd to delete a single buffer
nnoremap ZQ :qall!<CR>

""" Easily quit help pages
augroup Help
  autocmd!
  autocmd FileType help nnoremap <buffer> q :q<CR>
  autocmd BufEnter option-window nnoremap <buffer> q :q<CR>
augroup END



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INDENTATION AND STYLING                                                                                           {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Preserve visual block after indenting, increment/decrement
vnoremap > >gv
vnoremap < <gv
vnoremap <C-A> <C-A>gv
vnoremap <C-X> <C-X>gv

""" Change window size (gui only)
if has('gui_running')
  nnoremap <silent> >l  :<C-U>execute 'let &lines     += ' . v:count1<CR>
  nnoremap <silent> <l  :<C-U>execute 'let &lines     -= ' . v:count1<CR>
  nnoremap <silent> >c  :<C-U>execute 'let &columns   += ' . v:count1<CR>
  nnoremap <silent> <c  :<C-U>execute 'let &columns   -= ' . v:count1<CR>
  nnoremap <silent> >s  :<C-U>execute 'let &linespace += ' . v:count1<CR>
  nnoremap <silent> <s  :<C-U>execute 'let &linespace  = ' . (&linespace - v:count1)<CR>
endif

""" Toggle Commands
nnoremap yOu :tabdo windo set cursorcolumn!<CR>
nnoremap yOw :tabdo windo set wrap!<CR>
nnoremap yOx :tabdo windo set cursorline! cursorcolumn!<CR>
nnoremap <expr> yok ':setlocal colorcolumn=' . (&colorcolumn=='0' ? '+1' : 0) . '<CR>'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NAVIGATION                                                                                                        {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Move by visual lines
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
noremap <silent> gj j
noremap <silent> gk k

nnoremap gm :call cursor(0, virtcol('$')/2)<CR>

""" View/scrolling
nnoremap <silent> zh    3zh
nnoremap <silent> zl    3zl
nnoremap <silent> <C-E> 3<C-E>
nnoremap <silent> <C-Y> 3<C-Y>

" Toggle the cursor line to be fixed in the middle of the screen
nnoremap <silent> <leader>zz :let &scrolloff=999-&scrolloff<CR>

nnoremap <expr> <CR> foldlevel('.') ? 'za' : '<CR>'

""" Visually select the text that was last edited/pasted
nnoremap gV `[v`]



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BUFFERS, WINDOWS, TABS                                                                                            {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Force close and re-split
nnoremap <silent> <C-W><S-V> <C-W><C-O><C-W><C-V>
nnoremap <silent> <C-W><S-S> <C-W><C-O><C-W><C-S>

""" Close windows above/below/to the left/right of the current one
nnoremap <silent> <C-W><S-C>h <C-W><C-H><C-W>c
nnoremap <silent> <C-W><S-C>j <C-W><C-J><C-W>c
nnoremap <silent> <C-W><S-C>k <C-W><C-K><C-W>c
nnoremap <silent> <C-W><S-C>l <C-W><C-L><C-W>c

""" Toggle between all buffers and all tabs
nnoremap <silent> <expr> <F8> (tabpagenr('$') == 1 ? ':tab ball<Bar>tabn' : ':tabo') . '<CR>'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCH AND REPLACE                                                                                                {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Mode   | Map        | Description                                                                             |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Normal | *    #     | Search whole-word under cursor                                                          |
" |        | g*   g#    | Search word under cursor                                                                |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Normal | <leader>*  | Set search pattern to whole-word under cursor                                           |
" |        | <leader>g* | Set search pattern to word under cursor                                                 |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Normal | g/         | Grep all files containing the search term and show results in a quickfix-list           |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Visual | /    ?     | Open search with visual selection but don't start searching                             |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Visual | *    #     | Start searching whole-word with visual selection                                        |
" |        | g*   g#    | Start search with visual selection                                                      |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Visual | &          | Open substitute with visual selection                                                   |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Visual | <leader>*  | Set visual selection as the search pattern                                              |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Visual | g/         | Grep all files containing the visual selection and show results in a quickfix-list      |
" |--------+------------+-----------------------------------------------------------------------------------------|

""" Use very-magic while searching (Perl-style regex)
nnoremap / /\v
nnoremap ? ?\v
cnoremap %s/ %s/\v
cnoremap .s/ .s/\v
xnoremap :s/ :s/\%V\v

""" Search with visual selection
vnoremap *  <ESC>/\<<C-R>=escape(@*, '$*[]\/')<CR>\><CR>
vnoremap g* <ESC>/<C-R>=escape(@*, '$*[]\/')<CR><CR>
vnoremap #  <ESC>?\<<C-R>=escape(@*, '$*[]\/')<CR>\><CR>
vnoremap g# <ESC>?<C-R>=escape(@*, '$*[]\/')<CR><CR>

""" Start substitute with visual selection
vnoremap & <ESC>:%s/<C-R>=escape(@*, '$*[]\\|\/')<CR>/

""" Set search pattern without moving the cursor
nnoremap <silent> <leader>*  :let @/='\<'.escape(expand('<cword>'),'$*[]/').'\>'<CR>
vnoremap <silent> <leader>*  :<C-U>let @/='\<'.escape(@*,'$*[]/').'\>'<CR>

nnoremap <silent> <leader>g* :let @/=escape(expand('<cword>'),'$*[]/')<CR>
vnoremap <silent> <leader>g* :<C-U>let @/=escape(@*,'$*[]/')<CR>

""" Grep
command! -nargs=+ -complete=file -bar Grep silent grep! <args>|botright cwindow 20|redraw!
nnoremap g/ :Grep<Space>

""" Replace word under the cursor. Type replacement, press <ESC>. Use . to jump to next and repeat
nnoremap c*  *<C-O>cgn
nnoremap cg* g*<C-O>cgn



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC                                                                                                              {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Ctrl+S to save
nnoremap <silent> <C-S> :execute ':silent :wall!'<CR>
imap     <silent> <C-S> <C-\><C-O><C-S>

""" Jump to corresponding <Tag> (AMD)
nmap <leader>< va><ESC>:<C-U>/<C-R>*<CR>
