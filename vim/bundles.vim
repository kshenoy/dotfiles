"
" PLUGINS
"

" Automatically install plugins
let s:plug_path=expand(g:dotvim . '/autoload/plug.vim')
if !filereadable(s:plug_path)
  execute 'silent !curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source ' . s:plug_path
  augroup Plug
    autocmd!
    autocmd VimEnter * PlugInstall --sync
  augroup END
endif

call plug#begin(expand(g:dotvim . '/pack/bundles/opt/'))

function! s:PlugCond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#('ctrlpvim/ctrlp.vim')
call plug#('tacahiroy/ctrlp-funky')
call plug#('FelikZ/ctrlp-py-matcher',          s:PlugCond(has('python')||has('python3')))
" Plug '/home/kshenoy/.local/install/fzf'
" call plug#('junegunn/fzf.vim')
if has('python3')
  call plug#('ivan-cukic/vim-ctrlp-switcher',  {'on': ['CtrlPSwitch', 'CtrlPSwitchBasic', 'CtrlPSwitchFull']})
endif

" Motion/TextObjects ---------------------------------------------------------------------------------------------------
runtime! macros/matchit.vim

call plug#('PeterRincker/vim-argumentative')
" call plug#('justinmk/vim-sneak')
call plug#('chaoren/vim-wordmotion')
call plug#('rhysd/vim-textobj-word-column',    {'on': '<Plug>(textobj-wordcolumn'})
call plug#('kana/vim-textobj-user')
call plug#('glts/vim-textobj-comment',         {'on': '<Plug>(textobj-comment'})
call plug#('kana/vim-textobj-entire',          {'on': '<Plug>(textobj-entire'})
call plug#('kana/vim-textobj-function',        {'on': '<Plug>(textobj-function'})
call plug#('kana/vim-textobj-indent',          {'on': '<Plug>(textobj-indent'})
call plug#('kana/vim-textobj-line',            {'on': '<Plug>(textobj-line'})
call plug#('saihoooooooo/vim-textobj-space',   {'on': '<Plug>(textobj-space'})
" call plug#('tommcdo/vim-express')

" Completion/Text insertion --------------------------------------------------------------------------------------------
call plug#('dawikur/algorithm-mnemonics.vim',  {'for': 'cpp'})
call plug#('lifepillar/vim-mucomplete')
call plug#('Raimondi/delimitMate')
call plug#('tpope/vim-endwise')
call plug#('SirVer/ultisnips',                 s:PlugCond(has('python')||has('python3')))
call plug#('tpope/vim-commentary',             {'on': '<Plug>Commentary'})
call plug#('kshenoy/vim-origami')
" call plug#('dhruvasagar/vim-table-mode')
" call plug#('vim-scripts/DrawIt')
call plug#('junegunn/vim-easy-align',          {'on': ['EasyAlign', '<Plug>(EasyAlign)']})
call plug#('tommcdo/vim-exchange',             {'on': '<Plug>(Exchange'})
call plug#('triglav/vim-visual-increment',     {'on': '<Plug>VisualIncrement'})
call plug#('AndrewRadev/switch.vim',           {'on': 'Switch'})

" Misc -----------------------------------------------------------------------------------------------------------------
call plug#('tpope/vim-abolish')
call plug#('chrisbra/vim-diff-enhanced')
call plug#('derekwyatt/vim-fswitch')
call plug#('w0rp/ale')
" call plug#('skywind3000/asyncrun.vim')
" call plug#('tpope/vim-dispatch')
call plug#('sjl/gundo.vim',                    {'on': 'GundoToggle'})
" call plug#('Yggdroot/indentLine',              PlugCond(has('conceal'), {'on': 'IndentLinesToggle'}))
call plug#('Valloric/ListToggle',              {'on': ['LToggle', 'QToggle']})


call plug#('tpope/vim-repeat')
call plug#('kshenoy/vim-signature')
" call plug#('kana/vim-submode')
call plug#('tpope/vim-surround')
call plug#('tpope/vim-unimpaired')
call plug#('tpope/vim-vinegar')
call plug#('octol/vim-cpp-enhanced-highlight', {'for': 'cpp'})

" FileTypes ------------------------------------------------------------------------------------------------------------
call plug#('WeiChungWu/vim-SystemVerilog',     {'for': 'systemverilog'})
call plug#('kshenoy/TWiki-Syntax',             {'for': 'twiki'})

" Colorshemes ----------------------------------------------------------------------------------------------------------
call plug#('chriskempson/base16-vim')
" call plug#('kshenoy/vim-sol')

" vim-mark -------------------------------------------------------------------------------------------------------- {{{1
map           <leader>m       <Plug>my(Mark)
nmap <silent> <Plug>my(Mark)m <Plug>MarkSet
xmap <silent> <Plug>my(Mark)m <Plug>MarkSet
nmap <silent> <Plug>my(Mark)n <Plug>MarkClear
nmap <silent> <Plug>my(Mark)x <Plug>MarkRegex
xmap <silent> <Plug>my(Mark)x <Plug>MarkRegex
nmap <silent> <Plug>my(Mark)* <Plug>MarkSearchGroupNext
xmap <silent> <Plug>my(Mark)* <Plug>MarkSearchGroupNext
nmap <silent> <Plug>my(Mark)# <Plug>MarkSearchGroupPrev
xmap <silent> <Plug>my(Mark)# <Plug>MarkSearchGroupPrev
nmap <silent> <Plug>my(Mark)/ <Plug>MarkSearchAnyNext
xmap <silent> <Plug>my(Mark)/ <Plug>MarkSearchAnyNext
nmap <silent> <Plug>my(Mark)? <Plug>MarkSearchAnyPrev
xmap <silent> <Plug>my(Mark)? <Plug>MarkSearchAnyPrev

nmap <Plug>IgnoreMarkSearchCurrentNext <Plug>MarkSearchCurrentNext
xmap <Plug>IgnoreMarkSearchCurrentNext <Plug>MarkSearchCurrentNext
nmap <Plug>IgnoreMarkSearchCurrentPrev <Plug>MarkSearchCurrentPrev
xmap <Plug>IgnoreMarkSearchCurrentPrev <Plug>MarkSearchCurrentPrev

call plug#('inkarkat/vim-mark')
" }}}1


call plug#end()


" Plugins - Settings ===================================================================================================
" ale ------------------------------------------------------------------------------------------------------------- {{{1
let g:ale_lint_on_enter=0
" let g:ale_open_list='never'
let g:ale_set_quickfix=0
let g:ale_set_balloons=0
let g:ale_sign_error='✗ '
let g:ale_sign_style_error='✠ '
" let g:ale_sign_warning='⚠ '
let g:ale_sign_warning='! '
let g:ale_echo_msg_format = '%linter%: %s'
let g:ale_cpp_clang_options = '-std=c++14'
let g:ale_cpp_clangtidy_options = '-std=c++14'

" Initialize list if it doesn't exist
let g:ale_cpp_clangtidy_checks = get(g:, 'ale_cpp_clangtidy_checks', [])
call add(g:ale_cpp_clangtidy_checks, '-google-build-using-namespace')
call add(g:ale_cpp_clangtidy_checks, 'llvm-header-guard')
call add(g:ale_cpp_clangtidy_checks, 'modernize-*')
call add(g:ale_cpp_clangtidy_checks, 'cpp-core-guidelines-*')

let g:ale_linters = { 'cpp' : ['clang', 'clangtidy'] }
let g:ale_fixers  = { 'cpp' : ['clang-format'] }

nnoremap [s  :ALEPreviousWrap<CR>
nnoremap ]s  :ALENextWrap<CR>
nnoremap [S  :ALEFirst<CR>
nnoremap ]S  :ALENext<CR>
nnoremap =sf :ALEFix<CR>
nnoremap =sl :ALELint<CR>
nnoremap =S  :ALEDetail<CR>
nnoremap yoS :ALEToggle<CR>


" AutoComplPop ---------------------------------------------------------------------------------------------------- {{{1
let g:acp_completeoptPreview = 0                                              " Do not show tag previews when completing


" Base16 ---------------------------------------------------------------------------------------------------------- {{{1
let g:base16_shell_path=glob('~/.config/base16-shell/scripts/')


" Commentary ------------------------------------------------------------------------------------------------------ {{{1
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

augroup Commentary
  autocmd FileType xdefaults let &commentstring='!%s'
augroup END


" vim-cpp-enhanced-highlight -------------------------------------------------------------------------------------- {{{1
let g:cpp_class_scope_highlight           = 1
let g:cpp_member_variable_highlight       = 1
let g:cpp_class_decl_highlight            = 1
let g:cpp_experimental_template_highlight = 0

highlight link cCustomFunc   cppStatement
highlight link cCustomMemvar cppStructure
highlight link cCustomClass  cCustomClassName


" CtrlP ----------------------------------------------------------------------------------------------------------- {{{1
let g:ctrlp_map                 = ''
let g:ctrlp_cmd                 = ''
let g:ctrlp_buftag_ctags_bin    = '/tool/pandora64/latest/bin/ctags'
let g:ctrlp_by_filename         = 1
let g:ctrlp_switch_buffer       = 'H'        " Jump to window anywhere when C-x is pressed. Pressing <CR> will just open
let g:ctrlp_root_markers        = ['P4CONFIG']
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden         = 0
let g:ctrlp_max_files           = 0
let g:ctrlp_extensions          = [ 'mixed', 'bookmarkdir', 'funky' ]
let g:ctrlp_follow_symlinks     = 1
if has('python')
  let g:ctrlp_match_func        = {'match': 'pymatcher#PyMatch'}
endif
" let g:ctrlp_cache_dir           =

if has('unix')
  let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
      \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
      \ 3: ['P4CONFIG', 'p4 have %s/...']
    \ },
    \ 'fallback': "find %s -type d \\( -iname .svn -o -iname .git -o -iname .hg \\) -prune -o " .
                        \ "-type f ! \\( -name '.*' -o -iname '*.log' -o -iname '*.out' -o -iname '*.so' -o " .
                        \ "              -iname '*.cc.o' -o -iname *tags*' \\) -print " .
                        \ "| while read filename; do echo ${#filename} $filename; done " .
                        \ "| sort -n | awk '{print $2}'"
  \ }

elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
elseif executable('pt')
  let g:ctrlp_user_command = 'pt %s -l --nocolor'
endif

"let g:ctrlp_abbrev = {
"  \ 'gmode': 'i',
"  \ 'abbrevs': [
"    \ {
"      \ 'pattern': '^cd b',
"      \ 'expanded': '@cd ~/.vim/bundle',
"      \ 'mode': 'pfrz',
"    \ },
"    \ {
"      \ 'pattern': '\(^@.\+\|\\\@<!:.\+\)\@<! ',
"      \ 'expanded': '.\{-}',
"      \ 'mode': 'pfr',
"    \ },
"    \ {
"      \ 'pattern': '\\\@<!:.\+\zs\\\@<! ',
"      \ 'expanded': '\ ',
"      \ 'mode': 'pfz',
"    \ },
"  \ ]
"\ }

" <C-N>, <C-P> and <C-O> to match Helm's defaults
let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")': ['<C-N>'],
  \ 'PrtSelectMove("k")': ['<C-P>'],
  \ 'PrtHistory(-1)':     ['<Down>'],
  \ 'PrtHistory(1)':      ['<Up>'],
  \ 'ToggleType(1)':      ['<C-L>'],
  \ 'ToggleType(-1)':     ['<C-H>'],
  \ }

map      <leader>j <Plug>my(CtrlP)
nnoremap <silent>  <Plug>my(CtrlP)a :CtrlPSwitchBasic<CR>
nnoremap <silent>  <Plug>my(CtrlP)b :CtrlPBuffer<CR>
nnoremap <silent>  <Plug>my(CtrlP)e :CtrlPCurWD<CR>
nnoremap <silent>  <Plug>my(CtrlP)f :CtrlP<CR>
nnoremap <silent>  <Plug>my(CtrlP)j :CtrlPMixed<CR>
nnoremap <silent>  <Plug>my(CtrlP)r :CtrlPMRU<CR>
nnoremap <silent>  <Plug>my(CtrlP)q :CtrlPQuickfix<CR>
nnoremap <silent>  <Plug>my(CtrlP)t :CtrlPTag<CR>
nnoremap <silent>  <Plug>my(CtrlP)o :CtrlPFunky<CR>
xnoremap <silent>  <Plug>my(CtrlP)o :<C-U>CtrlPFunky <C-R>*<CR>
nnoremap <silent>  <Plug>my(CtrlP)] :CtrlPtjump<CR>
vnoremap <silent>  <Plug>my(CtrlP)] :CtrlPtjumpVisual<CR>
nnoremap <silent>  <leader><leader> :CtrlPBuffer<CR>

let g:ctrlpswitcher_mode=1


" delimitMate ----------------------------------------------------------------------------------------------------- {{{1
augroup delimitMate_my
  autocmd!
  autocmd FileType systemverilog let b:delimitMate_quotes = "\" '"
augroup END


" vim-easy-align -------------------------------------------------------------------------------------------------- {{{1
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = { '>': { 'pattern': '>>\|=>\|>' },
                            \   '/': {
                            \       'pattern':         '//\+\|/\*\|\*/',
                            \       'delimiter_align': 'l',
                            \       'ignore_groups':   ['!Comment']
                            \   },
                            \   ']': {
                            \       'pattern':       '[[\]]',
                            \       'left_margin':   0,
                            \       'right_margin':  0,
                            \       'stick_to_left': 0
                            \   },
                            \   '(': {
                            \       'pattern':       '[(]',
                            \       'left_margin':   0,
                            \       'right_margin':  0,
                            \       'stick_to_left': 0
                            \   },
                            \   ')': {
                            \       'pattern':       '[)]',
                            \       'left_margin':   0,
                            \       'right_margin':  0,
                            \       'stick_to_left': 0
                            \   }
                            \ }


" vim-exchange ---------------------------------------------------------------------------------------------------- {{{1
nmap cx  <Plug>(Exchange)
nmap cxc <Plug>(ExchangeClear)
xmap X   <Plug>(Exchange)


" vim-express ----------------------------------------------------------------------------------------------------- {{{1
" function! s:InitVimExpress()
"   " Description: Creates operators upon startup as the plugin might not have beeen loaded at this point
"   MapExpress gs join(sort(split(v:val, '\n')), '')
" endfunction
"
" augroup BundleInit
"   autocmd!
"   autocmd VimEnter * call s:InitVimExpress()
" augroup END


" FSwitch --------------------------------------------------------------------------------------------------------- {{{1
let g:fsnonewfiles = 1
augroup FSwitch
  autocmd!
  autocmd BufEnter *.h   let b:fswitchdst = 'c,cc,cpp,tpp'
  autocmd BufEnter *.cc  let b:fswitchdst = 'hh,h'
  autocmd BufEnter *.cpp let b:fswitchdst = 'hpp,h'
  autocmd BufEnter *.tpp let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|'
  autocmd BufEnter *.tpp let b:fswitchdst = 'hpp,h'
augroup END

map      gof      <Plug>my(FSwitch)
nnoremap <silent> <Plug>my(FSwitch)f :FSHere<CR>
nnoremap <silent> <Plug>my(FSwitch)h :FSLeft<CR>
nnoremap <silent> <Plug>my(FSwitch)j :FSBelow<CR>
nnoremap <silent> <Plug>my(FSwitch)k :FSAbove<CR>
nnoremap <silent> <Plug>my(FSwitch)l :FSRight<CR>
nnoremap <silent> <Plug>my(FSwitch)H <C-W><C-O>:FSSplitLeft<CR>
nnoremap <silent> <Plug>my(FSwitch)J <C-W><C-O>:FSSplitBelow<CR>
nnoremap <silent> <Plug>my(FSwitch)K <C-W><C-O>:FSSplitAbove<CR>
nnoremap <silent> <Plug>my(FSwitch)L <C-W><C-O>:FSSplitRight<CR>
nnoremap <silent> <S-CR>             :FSHere<CR>


" Gundo ----------------------------------------------------------------------------------------------------------- {{{1
let g:gundo_preview_bottom=1
nnoremap yoU :GundoToggle<CR>


" IndentLine ------------------------------------------------------------------------------------------------------ {{{1
let g:indentLine_char = "┊"


" ListToggle ------------------------------------------------------------------------------------------------------ {{{1
nnoremap yoL :LToggle<CR>
nnoremap yoQ :QToggle<CR>


" vim-mucomplete -------------------------------------------------------------------------------------------------- {{{1
let g:mucomplete#chains = {
  \ 'default': ['path', 'omni', 'keyn', 'dict', 'c-n', 'user', 'ulti']
  \ }
let g:mucomplete#enable_auto_at_startup = 0
let g:mucomplete#no_popup_mappings = 0


" Origami --------------------------------------------------------------------------------------------------------- {{{1
let g:OrigamiFoldAtCol = -4


" vim-parjumper --------------------------------------------------------------------------------------------------- {{{1
" map g{ <Plug>(ParJumpBackward)
" map g} <Plug>(ParJumpForward)


" Repeat ---------------------------------------------------------------------------------------------------------- {{{1
nnoremap <silent> <C-R> :<C-U>call repeat#wrap('U',v:count)<CR>
nnoremap <silent> U     :<C-U>call repeat#wrap("\<Lt>C-R>",v:count)<CR>


" Signature ------------------------------------------------------------------------------------------------------- {{{1
let g:SignatureMarkTextHLDynamic   = 1
let g:SignatureMarkerTextHLDynamic = 1
if exists('*signature#marker#Goto')
  for i in range(1,9)
    execute 'nnoremap <silent> ]' . i . ' :<C-U>call signature#marker#Goto("next", ' . i .', v:count)<CR>'
    execute 'nnoremap <silent> [' . i . ' :<C-U>call signature#marker#Goto("prev", ' . i .', v:count)<CR>'
  endfor
endif


" Sneak ----------------------------------------------------------------------------------------------------------- {{{1
" highlight link SneakPluginScope  CursorLine
" highlight link SneakPluginTarget Normal

" " Mimic Clever-f
" let g:sneak#s_next = 1

" " Disable the 's' map and next/prev maps
" map gs <Plug>Sneak_s
" map gS <Plug>Sneak_S
" " 1-character _inclusive_ Sneak (for enhanced 'f')
" map f <Plug>Sneak_f
" map F <Plug>Sneak_F
" " 1-character _exclusive_ Sneak (for enhanced 't')
" map t <Plug>Sneak_t
" map T <Plug>Sneak_T


" Submode --------------------------------------------------------------------------------------------------------- {{{1
let g:submode_always_show_submode = 1
let g:submode_keep_leaving_key    = 1

" if exists('*submode#')
"   call submode#enter_with( 'WinResize', 'n', '', '<C-W><'      , '<C-W><'       )
"   call submode#map       ( 'WinResize', 'n', '', '<'           , '<C-W><'       )
"   call submode#enter_with( 'WinResize', 'n', '', '<C-W>>'      , '<C-W>>'       )
"   call submode#map       ( 'WinResize', 'n', '', '>'           , '<C-W>>'       )
"   call submode#enter_with( 'WinResize', 'n', '', '<C-W>+'      , '<C-W>+'       )
"   call submode#map       ( 'WinResize', 'n', '', '+'           , '<C-W>+'       )
"   call submode#enter_with( 'WinResize', 'n', '', '<C-W>-'      , '<C-W>-'       )
"   call submode#map       ( 'WinResize', 'n', '', '-'           , '<C-W>-'       )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>h'      , '<C-W>h'       )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>j'      , '<C-W>j'       )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>k'      , '<C-W>k'       )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>l'      , '<C-W>l'       )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-H>'  , '<C-W><C-H>'   )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-J>'  , '<C-W><C-J>'   )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-K>'  , '<C-W><C-K>'   )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-L>'  , '<C-W><C-L>'   )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Up>'   , '<C-W><Up>'    )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Down>' , '<C-W><Down>'  )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Left>' , '<C-W><Left>'  )
"   call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Right>', '<C-W><Right>' )
"   call submode#map       ( 'WinMove'  , 'n', '', 'h'           , '<C-W>h'       )
"   call submode#map       ( 'WinMove'  , 'n', '', 'j'           , '<C-W>j'       )
"   call submode#map       ( 'WinMove'  , 'n', '', 'k'           , '<C-W>k'       )
"   call submode#map       ( 'WinMove'  , 'n', '', 'l'           , '<C-W>l'       )
"   call submode#map       ( 'WinMove'  , 'n', '', '<C-H>'       , '<C-W><C-H>'   )
"   call submode#map       ( 'WinMove'  , 'n', '', '<C-J>'       , '<C-W><C-J>'   )
"   call submode#map       ( 'WinMove'  , 'n', '', '<C-K>'       , '<C-W><C-K>'   )
"   call submode#map       ( 'WinMove'  , 'n', '', '<C-L>'       , '<C-W><C-L>'   )
"   call submode#map       ( 'WinMove'  , 'n', '', '<Up>'        , '<C-W><Up>'    )
"   call submode#map       ( 'WinMove'  , 'n', '', '<Down>'      , '<C-W><Down>'  )
"   call submode#map       ( 'WinMove'  , 'n', '', '<Left>'      , '<C-W><Left>'  )
"   call submode#map       ( 'WinMove'  , 'n', '', '<Right>'     , '<C-W><Right>' )
"   call submode#enter_with( 'Indent'   , 'n', '', '>>'          , '>>'           )
"   call submode#enter_with( 'Indent'   , 'n', '', '<<'          , '<<'           )
"   call submode#map       ( 'Indent'   , 'n', '', '>'           , '>>'           )
"   call submode#map       ( 'Indent'   , 'n', '', '<'           , '<<'           )
"   call submode#enter_with( 'WinCycle' , 'n', '', '<C-W><C-W>'  , '<C-W><C-W>'   )
"   call submode#enter_with( 'WinCycle' , 'n', '', '<C-W>w'      , '<C-W>w'       )
"   call submode#enter_with( 'WinCycle' , 'n', '', '<C-W>W'      , '<C-W>W'       )
"   call submode#map       ( 'WinCycle' , 'n', '', '<C-W>'       , '<C-W><C-W>'   )
"   call submode#map       ( 'WinCycle' , 'n', '', 'w'           , '<C-W>w'       )
"   call submode#map       ( 'WinCycle' , 'n', '', 'W'           , '<C-W>W'       )

"   call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-N>',   '<Leader>m<C-N>')
"   call submode#map       ('mark.vim', 'n', '', '<C-N>',            '<Leader>m<C-N>')
"   call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-P>',   '<Leader>m<C-P>')
"   call submode#map       ('mark.vim', 'n', '', '<C-P>',            '<Leader>m<C-P>')
"   call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-A-N>', '<Leader>m<C-A-N>')
"   call submode#map       ('mark.vim', 'n', '', '<C-A-N>',          '<Leader>m<C-A-N>')
"   call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-A-P>', '<Leader>m<C-A-P>')
"   call submode#map       ('mark.vim', 'n', '', '<C-A-P>',          '<Leader>m<C-A-P>')

"   " Custom Maps
"   nnoremap <Plug>IncLines :<C-U>let &lines += 1<CR>
"   nnoremap <Plug>DecLines :<C-U>let &lines -= 1<CR>
"   call submode#enter_with( 'ResizeLines', 'n', 'r', '>l', '<Plug>IncLines' )
"   call submode#enter_with( 'ResizeLines', 'n', 'r', '<l', '<Plug>DecLines' )
"   call submode#map       ( 'ResizeLines', 'n', 'r', '>' , '<Plug>IncLines' )
"   call submode#map       ( 'ResizeLines', 'n', 'r', '<' , '<Plug>DecLines' )
"   nnoremap <Plug>IncColumns :<C-U>let &columns += 1<CR>
"   nnoremap <Plug>DecColumns :<C-U>let &columns -= 1<CR>
"   call submode#enter_with( 'ResizeColumns', 'n', 'r', '>c', '<Plug>IncColumns' )
"   call submode#enter_with( 'ResizeColumns', 'n', 'r', '<c', '<Plug>DecColumns' )
"   call submode#map       ( 'ResizeColumns', 'n', 'r', '>' , '<Plug>IncColumns' )
"   call submode#map       ( 'ResizeColumns', 'n', 'r', '<' , '<Plug>DecColumns' )
"   nnoremap <Plug>IncLineSpace :<C-U>let &linespace += 1<CR>
"   nnoremap <Plug>DecLineSpace :<C-U>let &linespace -= 1<CR>
"   call submode#enter_with( 'ResizeLsp', 'n', 'r', '>s', '<Plug>IncLineSpace' )
"   call submode#enter_with( 'ResizeLsp', 'n', 'r', '<s', '<Plug>DecLineSpace' )
"   call submode#map       ( 'ResizeLsp', 'n', 'r', '>' , '<Plug>IncLineSpace' )
"   call submode#map       ( 'ResizeLsp', 'n', 'r', '<' , '<Plug>DecLineSpace' )
"   nnoremap <Plug>IncFontSize :<C-U>IncFontSize<CR>
"   nnoremap <Plug>DecFontSize :<C-U>DecFontSize<CR>
"   call submode#enter_with( 'ResizeFont', 'n', 'r', '<f', '<Plug>DecFontSize' )
"   call submode#enter_with( 'ResizeFont', 'n', 'r', '>f', '<Plug>IncFontSize' )
"   call submode#map       ( 'ResizeFont', 'n', 'r', '<' , '<Plug>DecFontSize' )
"   call submode#map       ( 'ResizeFont', 'n', 'r', '>' , '<Plug>IncFontSize' )
" endif


" Solarized ------------------------------------------------------------------------------------------------------- {{{1
let g:solarized_underline = 0
"let g:solarized_visibility = "high"


" Switch ---------------------------------------------------------------------------------------------------------- {{{1
nnoremap <BS> :Switch<CR>
let g:switch_mapping = ''
let g:switch_custom_definitions = [
                                \   [ 'TRUE', 'FALSE' ],
                                \   [ 'pass', 'fail'  ],
                                \   [ 'Pass', 'Fail'  ],
                                \   [ 'PASS', 'FAIL'  ]
                                \ ]


" TableMode ------------------------------------------------------------------------------------------------------- {{{1
let g:table_mode_map_prefix = '<Plug>[table]'
nnoremap yoB :TableModeToggle<CR>


" vim-textobj-* --------------------------------------------------------------------------------------------------- {{{1
let g:textobj_comment_no_default_key_mappings    = 1
let g:textobj_entire_no_default_key_mappings     = 1
let g:textobj_function_no_default_key_mappings   = 1
let g:textobj_indent_no_default_key_mappings     = 1
let g:textobj_line_no_default_key_mappings       = 1
let g:textobj_space_no_default_key_mappings      = 1
let g:textobj_wordcolumn_no_default_key_mappings = 1

for s:mode in ['x', 'o']
  for s:motion in ['i', 'a']
    execute s:mode . 'map ' . s:motion . 'c       <Plug>(textobj-comment-'      . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '%       <Plug>(textobj-entire-'       . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'f       <Plug>(textobj-function-'     . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'F       <Plug>(textobj-function-'     . toupper(s:motion) . ')'
    execute s:mode . 'map ' . s:motion . 'i       <Plug>(textobj-indent-same-'  . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'I       <Plug>(textobj-indent-'       . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '_       <Plug>(textobj-line-'         . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . '<Space> <Plug>(textobj-space-'        . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'v       <Plug>(textobj-wordcolumn-w-' . s:motion          . ')'
    execute s:mode . 'map ' . s:motion . 'V       <Plug>(textobj-wordcolumn-W-' . s:motion          . ')'
  endfor
  execute s:mode . 'map ' . 'a' . 'C <Plug>(textobj-comment-big-a)'
endfor

"" Common-case is not to format a single line but to format the entire file.
"" Formatting the entire file doesn't need a count. Hence, if a count is given, assume we want to format lines instead.
"" Note that line formatting can also be done using gqgq
nnoremap <silent> <expr> gqq (v:count == 0 ? ":call utils#Preserve('normal gqi%')<CR>" : ":normal " . v:count . "gqq<CR>")


" Targets --------------------------------------------------------------------------------------------------------- {{{1
let g:targets_separators = ', . ; : + - = ~ * # / | \ & $'


" UltiSnips ------------------------------------------------------------------------------------------------------- {{{1
let g:UltiSnipsEditSplit = "vertical"
" Location of snippets
execute 'let g:UltiSnipsSnippetDirectories=["' . g:dotvim . '/pack/settings/start/UltiSnips/snippets"]'
let g:UltiSnipsEnableSnipMate=0
let g:UltiSnipsExpandTrigger='<S-Tab>'


" vim-vinegar ----------------------------------------------------------------------------------------------------- {{{1
nnoremap - <Plug>VinegarUp


" vim-wordmotion -------------------------------------------------------------------------------------------------- {{{1
let g:wordmotion_mappings = {
\ 'w':          '<M-w>',
\ 'b':          '<M-b>',
\ 'e':          '<M-e>',
\ 'ge':         'g<M-e>',
\ 'aw':         'a<M-w>',
\ 'iw':         'i<M-w>',
\ '<C-R><C-W>': '<C-R><M-w>'
\ }
