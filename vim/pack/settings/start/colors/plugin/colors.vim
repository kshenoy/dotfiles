let s:config_file = glob('~/.vimrc_background')

function! s:ReadBase16Config()                                                                                     "{{{1
  if filereadable(expand('~/.vimrc_background'))
    silent! source ~/.vimrc_background
    call s:After()
  endif
endfunction


function! s:After()                                                                                                "{{{1
  " Description: Find any additional settings related to the current colorscheme in after/colors and load it
  "              This order is important. We let statusline set the general colors first based on the colorscheme and
  "              then pick up any specific settings from the after file
  " Loading a colorscheme blows away old highlights breaking the behavior of vim-mark and other plugins which setup
  " custom highlight groups so this function tries to restore them
  call s:RestoreCustomHLGroups()

  if !exists('g:colors_name') || (g:colors_name == '')
    return
  endif

  let l:colors_name = g:colors_name
  if (g:colors_name =~ "solarized")
    let l:colors_name = "solarized"
  endif

  " This is a deliberate choice to stick the file under after/colors. This is because if it's under after/plugin then
  " the code seems to be run before the colorscheme gets loaded and thus can't be relied upon to run everytime.
  let l:color_file = g:dotvim . "/pack/settings/start/colors/after/colors/" . l:colors_name . ".vim"
  if filereadable(l:color_file)
    execute "source " . l:color_file
  endif
endfunction


function! s:RestoreCustomHLGroups()                                                                                "{{{1
  " Description: Highlight groups to use in Statusline

  highlight clear SignColumn
  highlight link  SignColumn LineNr
  highlight clear StatusLine
  highlight link  StatusLine LineNr

  let l:prefix = (has('gui_running') || has('termguicolors') ? 'gui' : 'cterm')
  let l:stl_bg=get(utils#GetHighlightInfo('StatusLine'), l:prefix . 'bg', '')

  for i in [
         \   ['STLColumn',   'CursorLineNr'],
         \   ['STLMarker',   'Function'    ],
         \   ['STLFilename', 'StatusLine'  ],
         \   ['STLStatus',   'Statement'   ]
         \ ]
    if l:stl_bg != ""
      silent execute 'highlight ' . i[0] . ' ' . l:prefix . 'bg=' . l:stl_bg
    endif
    let l:fg = get(utils#GetHighlightInfo(i[1]), l:prefix . 'fg', '')
    if l:fg != ""
      silent execute 'highlight ' . i[0] . ' ' . l:prefix . 'fg=' . l:fg
    endif
  endfor
  silent execute 'highlight STLFilename ' . l:prefix '=bold'

  let l:norm_bg = get(utils#GetHighlightInfo('Normal'), l:prefix . 'bg', '')
  silent execute 'highlight STLHelp     ' . l:prefix . 'bg=Red3 ' . (l:norm_bg == "" ? "" : l:prefix . 'fg=' . l:norm_bg)

  if !has('gui_running')
    return
  endif

  " Approximations of the colors I want: Insert - Blue, Replace - Red, Visual - Orange, etc.
  " Colorscheme specific colors, if any, will be set from .vim/after/colors/<colorscheme>.vim
  silent execute 'highlight InsertCursor  guibg=DodgerBlue3'
  silent execute 'highlight ReplaceCursor guibg=Red3'
  silent execute 'highlight VisualCursor  guibg=Orange3'
  silent execute 'highlight CommandCursor guibg=Magenta3'
  silent execute 'highlight NormalCursor  guibg=Green' . (&background == 'light' ? '3' : '4')
  if l:norm_bg != ""
    silent execute 'highlight InsertCursor  guifg=' . l:norm_bg
    silent execute 'highlight ReplaceCursor guifg=' . l:norm_bg
    silent execute 'highlight VisualCursor  guifg=' . l:norm_bg
    silent execute 'highlight CommandCursor guifg=' . l:norm_bg
    silent execute 'highlight NormalCursor  guifg=' . l:norm_bg
  endif

  " Setup vim-mark's highlights
  MarkPalette original
endfunction
" }}}1


if has('autocmd')
  augroup Color
    autocmd!
    autocmd VimEnter,FocusGained * call s:ReadBase16Config()
    autocmd Colorscheme * call s:After()
  augroup END
endif
