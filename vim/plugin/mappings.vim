""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LEADER COMMANDS                                                                                                   {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



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

cnoreabbrev <expr> E ((getcmdtype() == ':' && getcmdline() ==# 'E') ? 'e <C-R>=fnameescape(expand("%:p:h"))."/"<CR><C-R>=utils#EatChar("\\s")<CR>' : 'E')

""" Display full path and filename
nnoremap <C-G> 2<C-G>

""" Copy the file name to unix visual select buffer
nnoremap <expr> y<C-G> ':let @' . (has('win_32') ? '+' : '*') . '="' . expand("%:p") . '"<CR>'

""" Open help in a vertically split window. Use `:set splitright` to open on the right
" From https://stackoverflow.com/a/3879737/734153
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

""" Tab
""" Preserve visual block after indenting, increment/decrement
vnoremap > >gv
vnoremap < <gv
vnoremap <C-A> <C-A>gv
vnoremap <C-X> <C-X>gv

""" Briefly show CursorLine and CursorColumn
nnoremap <silent> <F5> :call utils#CursorBlind()<cr>

""" Change font-size, line-spacing, window-size
if has('gui_running')
  nnoremap <silent> >l  :<C-U>execute 'let &lines     += ' . v:count1<CR>
  nnoremap <silent> <l  :<C-U>execute 'let &lines     -= ' . v:count1<CR>
  nnoremap <silent> >c  :<C-U>execute 'let &columns   += ' . v:count1<CR>
  nnoremap <silent> <c  :<C-U>execute 'let &columns   -= ' . v:count1<CR>
  nnoremap <silent> >s  :<C-U>execute 'let &linespace += ' . v:count1<CR>
  nnoremap <silent> <s  :<C-U>execute 'let &linespace  = ' . (&linespace - v:count1)<CR>
  nnoremap <silent> >f  :<C-U>'let &guifont=' . join(map(split(&guifont, ','), {key, val -> substitute(val, '\d\+$', '\=submatch(0)+1', '')}), ',')<CR>
  nnoremap <silent> <f  :<C-U>'let &guifont=' . join(map(split(&guifont, ','), {key, val -> substitute(val, '\d\+$', '\=submatch(0)-1', '')}), ',')<CR>
endif

""" Fill Text Width
command! -nargs=? FTW call utils#FillTW(<args>)
nnoremap <silent> <leader>fw :FTW<CR>

""" Toggle Commands
""" This are inspired and similar to vim-unimpaired. That uses "yo" to toggle stuff using setlocal
""" However sometimes I want to toggle things globally. For these, I use "yO" if the option supports setting it globally
nnoremap yOc :call utils#Preserve("tabdo windo set cursorline!")<CR>
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

""" Windows
" Swap Windows
nnoremap <silent> <C-W><C-X> :call utils#WindowSwap()<CR>

" Force close and re-split
nnoremap <silent> <C-W><S-V> <C-W><C-O><C-W><C-V>
nnoremap <silent> <C-W><S-S> <C-W><C-O><C-W><C-S>

" Close windows above/below/to the left/right of the current one
nnoremap <silent> <C-W><S-C>h <C-W><C-H><C-W>c
nnoremap <silent> <C-W><S-C>j <C-W><C-J><C-W>c
nnoremap <silent> <C-W><S-C>k <C-W><C-K><C-W>c
nnoremap <silent> <C-W><S-C>l <C-W><C-L><C-W>c

" Toggle Zoom
nnoremap + :<C-U>call utils#WindowToggleZoom()<CR>

" Toggle between all buffers and all tabs
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
" | Normal | <leader>/  | Display all lines in current buffer containing the search term in a location-list       |
" |        | <leader>g/ | Display all lines in all buffers containing the search term in a quickfix-list          |
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
" | Visual | <leader>/  | Display all lines in current buffer containing the visual selection in a location-list  |
" |--------+------------+-----------------------------------------------------------------------------------------|
" | Visual | <leader>g/ | Display all lines in window containing the visual selection in a quickfix-list          |
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
" This escape function is meant for use with normal substitution
vnoremap & <ESC>:%s/<C-R>=escape(@*, '$*[]\\|\/')<CR>/
" This escape function is meant only for use with verymagic substitution
"vnoremap & <ESC>:%s/\v<C-R>=escape(@*, '$%^*=+<>()[]{}&/')<CR>/

""" Set search pattern without moving the cursor
nnoremap <silent> <leader>*  :let @/='\<'.escape(expand('<cword>'),'$*[]/').'\>'<CR>
vnoremap <silent> <leader>*  :<C-U>let @/='\<'.escape(@*,'$*[]/').'\>'<CR>

nnoremap <silent> <leader>g* :let @/=escape(expand('<cword>'),'$*[]/')<CR>
vnoremap <silent> <leader>g* :<C-U>let @/=escape(@*,'$*[]/')<CR>

""" Find and show results in a LocationList (Buffer-specific)
nnoremap <silent> <leader>/ :call utils#FindAndList('local', 'normal')<CR>
vnoremap <silent> <leader>/ :<C-U>call utils#FindAndList('local', 'visual')<CR>

""" Find and show results in a QuickfixList
nnoremap <silent> <leader>g/ :call utils#FindAndList('global', 'normal')<CR>
vnoremap <silent> <leader>g/ :<C-U>call utils#FindAndList('global', 'visual')<CR>

""" Grep
command! -nargs=+ -complete=file -bar Grep silent grep! <args>|botright cwindow 20|redraw!
nnoremap g/ :Grep<Space>

""" Keep searches in middle of screen
nnoremap <silent> n :call utils#SearchSaveAndRestore()<CR>/<CR>zvzz
nnoremap <silent> N :call utils#SearchSaveAndRestore()<CR>?<CR>zvzz

""" Jump to corresponding <Tag> (AMD)
nmap <leader>< va><ESC>:<C-U>/<C-R>*<CR>

""" Clear search string itself (Save before clearing)
nnoremap <silent> <C-L> :call utils#SearchSaveAndRestore()<Bar>let @/=""<CR><C-L>
"nnoremap <S-F5> :set hlsearch!<CR>:set hlsearch?<cr>   " Use coh from Unimpaired

""" Remove trailing whitespace
nnoremap <silent> <leader>s<Space> :call utils#Preserve('%s/\v\s+$//')<CR>

""" Replace word under the cursor. Type replacement, press <ESC>. Use . to jump to next occurence of the word and repeat
""" Works only on recent patches, > 7xx
nnoremap c*  *<C-O>cgn
nnoremap cg* g*<C-O>cgn



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC                                                                                                              {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Ctrl+S functionality for save
nnoremap <silent> <C-S> :execute ':silent :wall!'<CR>
imap     <silent> <C-S> <C-\><C-O><C-S>

""" Run perforce diff on current file
nnoremap <silent> <leader>pd :call perforce#DiffCurrentFile()<CR>
nnoremap <silent> <leader>pe :call perforce#Checkout()<CR>

""" Convert the base of the number below the cursor
nnoremap <silent> g=b :echo utils#BaseConverter(expand('<cword>'), 2)<CR>
nnoremap <silent> g=o :echo utils#BaseConverter(expand('<cword>'), 8)<CR>
nnoremap <silent> g=d :echo utils#BaseConverter(expand('<cword>'), 10)<CR>
nnoremap <silent> g=x :echo utils#BaseConverter(expand('<cword>'), 16)<CR>
