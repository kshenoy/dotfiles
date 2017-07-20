let s:config_file = glob('~/.vimrc_background')

function! s:ReadBase16Config()                                                                                    " {{{1
  if has('gui_running')
    return
  endif
  " If Vim doesn't have TrueColor support uses 256 color space
  " FIXME: Expand this if to include a check for if the Terminal supports it as well
  " if !has('termguicolors')
    " This variable is used by the base16-color plugin
    let base16colorspace=256
  " endif

  if filereadable(expand('~/.vimrc_background'))
    source ~/.vimrc_background
  endif
endfunction


function! s:WriteBase16Config()                                                                                   " {{{1
  if (  !has('gui_running')
   \ && filewritable(s:config_file)
   \ )
    let l:color = substitute(g:colors_name, "base16-", "", "")
    call writefile([l:color . " " . &background], s:config_file)
  endif
endfunction


function! s:After()                                                                                               " {{{1
  " Description: Find any additional settings related to the current colorscheme in after/colors and load it
  highlight clear SignColumn
  highlight link  SignColumn LineNr

  " This order is important. We let statusline set the general colors first based on the colorscheme and then
  " pick up any specific settings from the after file
  call s:UpdateUserColors()

  if (  !exists('g:colors_name')
   \ || (g:colors_name == '')
   \ )
    return
  endif

  " call s:WriteBase16Config()

  " This is a deliberate choice to stick the file under after/colors. This is because if it's under after/plugin then
  " the code seems to be run before the colorscheme gets loaded and thus can't be relied upon to run everytime.
  let l:color_file = g:dotvim . "/pack/settings/start/colors/after/colors/" . g:colors_name . ".vim"
  if filereadable(l:color_file)
    execute "source " . l:color_file
  endif

  " Is this required?
  " call statusline#Refresh
endfunction


function! s:UpdateUserColors()                                                                                    " {{{1
  " Description: Highlight groups to use in Statusline

  " highlight clear StatusLine
  " highlight link  StatusLine LineNr

  let l:prefix = (has('gui_running') || has('termguicolors') ? 'gui' : 'cterm')
  let l:stlbg = synIDattr(synIDtrans(hlID('StatusLine')), 'bg', l:prefix)

  for i in [
         \   ['STLColumn',   'CursorLineNr'],
         \   ['STLMarker',   'Function'    ],
         \   ['STLFilename', 'StatusLine'  ],
         \   ['STLStatus',   'Statement'   ]
         \ ]
    let l:fg = synIDattr(synIDtrans(hlID(i[1])), 'fg', l:prefix)
    silent execute 'highlight ' . i[0] . ' ' . l:prefix . 'bg=' . l:stlbg . ' ' . l:prefix . 'fg=' . l:fg
  endfor
  silent execute 'highlight STLFilename ' . l:prefix '=bold'

  let l:norm_bg = synIDattr(synIDtrans(hlID('Normal')), 'bg', l:prefix)
  silent execute 'highlight STLHelp     ' . l:prefix . 'bg=Red3 ' . l:prefix . 'fg=' . l:norm_bg

  if !has('gui_running')
    return
  endif

  " Approximations of the colors I want: Insert - Blue, Replace - Red, Visual - Orange, etc.
  " Colorscheme specific colors, if any, will be set from .vim/after/colors/<colorscheme>.vim
  silent execute 'highlight InsertCursor  guibg=DodgerBlue3 guifg=' . l:norm_bg
  silent execute 'highlight ReplaceCursor guibg=Red3        guifg=' . l:norm_bg
  silent execute 'highlight VisualCursor  guibg=Orange3     guifg=' . l:norm_bg
  silent execute 'highlight CommandCursor guibg=Magenta3    guifg=' . l:norm_bg
  silent execute 'highlight NormalCursor  guibg=Green' . (&background == 'light' ? '3' : '4') . ' guifg=' . l:norm_bg
endfunction
" }}}1

call s:ReadBase16Config()

if has('autocmd')
  augroup Color
    autocmd!
    " autocmd FocusGained * call s:ReadBase16Config()
    autocmd Colorscheme * call s:After()
  augroup END
endif
