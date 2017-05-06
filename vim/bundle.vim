"
" PLUGINS
"

if (empty(glob(expand(g:dotvim).'/autoload/plug.vim')))
  silent execute "!curl -fLo ".expand(g:dotvim)."/autoload/plug.vim --create-dirs "
  \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall|PlugUpgrade
endif

call plug#begin(expand(g:dotvim . '/bundle/'))

function! PlugCond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

Plug  'tpope/vim-abolish'
Plug  'PeterRincker/vim-argumentative'
" Plug  'vim-scripts/AutoComplPop'
Plug  'chriskempson/base16-vim'
Plug  'tpope/vim-commentary',             {'on': '<Plug>Commentary'}
Plug  'ctrlpvim/ctrlp.vim'
Plug  'tacahiroy/ctrlp-funky'
Plug  'FelikZ/ctrlp-py-matcher',          PlugCond(has('python'))
Plug  'Raimondi/delimitMate'
"Plug 'vim-scripts/DrawIt'
Plug  'junegunn/vim-easy-align',          {'on': ['EasyAlign', '<Plug>(EasyAlign)']}
Plug  'tpope/vim-endwise'
Plug  'tommcdo/vim-exchange',             {'on': '<Plug>(Exchange'}
Plug  'derekwyatt/vim-fswitch'
Plug  'sjl/gundo.vim',                    {'on': 'GundoToggle'}
"Plug 'nathanaelkane/vim-indent-guides',  {'on': ['IndentGuidesToggle', 'IndentGuidesEnable']}
"Plug 'Yggdroot/indentLine',              PlugCond(has('conceal'), {'on': 'IndentLinesToggle'})
Plug  'Valloric/ListToggle',              {'on': ['LToggle', 'QToggle']}
Plug  'Yggdroot/vim-mark'
Plug  'matchit.zip'
" Plug  'lifepillar/vim-mucomplete'
Plug  'kshenoy/vim-origami'
Plug  'tpope/vim-repeat'
Plug  'kshenoy/vim-signature'
" Plug  'maxboisvert/vim-simple-complete'
" Plug  'justinmk/vim-sneak'
Plug  'kshenoy/vim-sol'
"Plug 'sjl/splice.vim',                   {'on': 'SpliceInit'}
Plug 'kana/vim-submode'
Plug  'tpope/vim-surround'
Plug  'AndrewRadev/switch.vim',           {'on': 'Switch'}
Plug  'WeiChungWu/vim-SystemVerilog',     {'for': 'systemverilog'}
Plug  'dhruvasagar/vim-table-mode',       {'on': ['TableModeToggle', 'TableModeEnable']}
" Plug  'wellle/targets.vim'
Plug  'kana/vim-textobj-user'
Plug  'glts/vim-textobj-comment',         {'on': '<Plug>(textobj-comment'}
Plug  'kana/vim-textobj-function',        {'on': '<Plug>(textobj-function'}
Plug  'kana/vim-textobj-indent',          {'on': '<Plug>(textobj-indent'}
Plug  'kana/vim-textobj-line',            {'on': '<Plug>(textobj-line'}
Plug  'saihoooooooo/vim-textobj-space',   {'on': '<Plug>(textobj-space'}
Plug  'rhysd/vim-textobj-word-column',    {'on': '<Plug>(textobj-wordcolumn'}
Plug  'kshenoy/TWiki-Syntax',             {'for': 'twiki'}
Plug  'SirVer/ultisnips',                 PlugCond(has('python'))
Plug  'tpope/vim-unimpaired'
Plug  'tpope/vim-vinegar',                {'on': '<Plug>VinegarUp'}
Plug  'chaoren/vim-wordmotion'
" Plug  'Valloric/YouCompleteMe',           {'do': './install.py --clang-completer'}
Plug  'kshenoy/vim-parjumper'

call plug#end()


" Plugins - Settings ===================================================================================================
" AutoComplPop ---------------------------------------------------------------------------------------------------  {{{1
let g:acp_completeoptPreview = 0                                              " Do not show tag previews when completing


" Base16 ---------------------------------------------------------------------------------------------------------  {{{1
let g:base16_shell_path=glob('~/.dotfiles/base16/shell/scripts')


" CommandT -------------------------------------------------------------------------------------------------------  {{{1
let g:CommandTMaxHeight = 20


" Commentary -----------------------------------------------------------------------------------------------------  {{{1
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

augroup Commentary
  autocmd FileType c,cpp,systemverilog let &commentstring='//%s'
  autocmd FileType xdefaults           let &commentstring='!%s'
augroup END


" CtrlP ----------------------------------------------------------------------------------------------------------  {{{1
let g:ctrlp_map                 = ''
let g:ctrlp_cmd                 = ''
let g:ctrlp_buftag_ctags_bin    = '/tool/pandora64/latest/bin/ctags'
let g:ctrlp_by_filename         = 1
let g:ctrlp_switch_buffer       = 'ET'
let g:ctrlp_root_markers        = ['P4CONFIG']
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden         = 0
let g:ctrlp_max_files           = 0
let g:ctrlp_extensions          = [ 'mixed', 'bookmarkdir', 'funky' ]
let g:ctrlp_follow_symlinks     = 1
if has('python')
  let g:ctrlp_match_func        = {'match': 'pymatcher#PyMatch'}
endif

if has('unix')
  " The 'while read fname' section sorts the filenames in descending order by length thereby allowing to find the
  " shortest occurence of a string
  let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
      \ 2: ['.hg', 'hg --cwd %s status -numac -I . $(hg root)'],
      \ 3: ['P4CONFIG', 'cd %s && cat <(p4 have | sed "s:^.*$PWD/::" | ' .
                                        \ 'grep -v "emu\|_env\|env_squash\|fp\|tools\|powerPro\|sdpx\|ch/variants\|' .
                                        \ 'ch/verif/dft\|ch/verif/txn/old_yml_DO_NOT_USE\|ch/syn") ' .
                                   \ '<(find import/avf -type f) | ' .
                               \ 'grep -v "\.\(so\|log\)"'
         \ ]
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

"let g:ctrlp_user_command = 'find %s -type d \( -iname .svn -o -iname .git -o -iname .hg \) -prune -o -type f -print'

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
  \ 'ToggleType(1)':      ['<C-O>', '<C-L>'],
  \ 'ToggleType(-1)':     ['<C-H>'],
  \ 'PrtCurLeft()':       ['<Left>'],
  \ 'PrtCurRight()':      ['<Right>'],
  \ }

map      <leader>j <Plug>my(CtrlP)
nnoremap <silent>  <Plug>my(CtrlP)b :CtrlPBuffer<CR>
nnoremap <silent>  <Plug>my(CtrlP)a :CtrlPArgs<CR>
nnoremap <silent>  <Plug>my(CtrlP)e :CtrlPCurWD<CR>
nnoremap <silent>  <Plug>my(CtrlP)f :CtrlP<CR>
nnoremap <silent>  <Plug>my(CtrlP)j :CtrlPMixed<CR>
nnoremap <silent>  <Plug>my(CtrlP)r :CtrlPMRU<CR>
nnoremap <silent>  <Plug>my(CtrlP)t :CtrlPTag<CR>
nnoremap <silent>  <Plug>my(CtrlP)o :CtrlPFunky<CR>
nnoremap <silent>  <Plug>my(CtrlP)] :CtrlPtjump<CR>
vnoremap <silent>  <Plug>my(CtrlP)] :CtrlPtjumpVisual<CR>
nnoremap <silent>  <leader><leader> :CtrlPBuffer<CR>


" delimitMate ----------------------------------------------------------------------------------------------------  {{{1
augroup delimitMate_my
  autocmd!
  autocmd FileType systemverilog let b:delimitMate_quotes = "\" '"
augroup END


" vim-easy-align -------------------------------------------------------------------------------------------------  {{{1
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


" vim-exchange ---------------------------------------------------------------------------------------------------  {{{1
nmap cx  <Plug>(Exchange)
nmap cxc <Plug>(ExchangeClear)
xmap X   <Plug>(Exchange)


" FSwitch --------------------------------------------------------------------------------------------------------  {{{1
let g:fsnonewfiles = 1
augroup FSwitch
  autocmd BufWinEnter *.cc  let b:fswitchdst = 'h'
  autocmd BufWinEnter *.cpp let b:fswitchdst = 'hpp,h'
  autocmd BufWinEnter *.h   let b:fswitchdst = 'c,cc,cpp'
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


" Gundo ----------------------------------------------------------------------------------------------------------  {{{1
nnoremap coU :GundoToggle<CR>


" IndentLine -----------------------------------------------------------------------------------------------------  {{{1
let g:indentLine_char = "┊"


" ListToggle -----------------------------------------------------------------------------------------------------  {{{1
nnoremap coL :LToggle<CR>
nnoremap coC :QToggle<CR>


" vim-mark -------------------------------------------------------------------------------------------------------  {{{1
map  <unique>          <leader>m             <Plug>my(Mark)
nmap <unique> <silent> <Plug>my(Mark)m       <Plug>MarkSet
xmap <unique> <silent> <Plug>my(Mark)m       <Plug>MarkSet
nmap <unique> <silent> <Plug>my(Mark)x       <Plug>MarkRegex
xmap <unique> <silent> <Plug>my(Mark)x       <Plug>MarkRegex
nmap <unique> <silent> <Plug>my(Mark)n       <Plug>MarkClear
nmap <unique> <silent> <Plug>my(Mark)<C-N>   <Plug>MarkSearchNext
nmap <unique> <silent> <Plug>my(Mark)<C-P>   <Plug>MarkSearchPrev
nmap <unique> <silent> <Plug>my(Mark)<C-A-N> <Plug>MarkSearchAnyNext
nmap <unique> <silent> <Plug>my(Mark)<C-A-P> <Plug>MarkSearchAnyPrev


" vim-markdown ---------------------------------------------------------------------------------------------------  {{{1
let g:markdown_fenced_languages = [ 'sh', 'bash=sh.bash', 'zsh=sh.bash.zsh', 'css', 'django', 'html', 'javascript',
                                  \ 'js=javascript', 'json=javascript', 'perl', 'php', 'python', 'ruby', 'sass', 'vim',
                                  \ 'xml' ]
let g:markdown_fold_style = 'nested'
let g:markdown_fold_override_foldtext = 0


" OmniCpp --------------------------------------------------------------------------------------------------------  {{{1
let g:mucomplete#chains = {
  \ 'default': ['path', 'omni', 'keyn', 'dict', 'c-n', 'user', 'ulti'],
  \ 'c':       ['path', 'omni', 'keyn', 'dict', 'c-n', 'user', 'ulti', 'tags'],
  \ 'cpp':     ['path', 'omni', 'keyn', 'dict', 'c-n', 'user', 'ulti', 'tags']
  \ }
let g:mucomplete#enable_auto_at_startup = 1


" OmniCpp --------------------------------------------------------------------------------------------------------  {{{1
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_MayCompleteScope    = 1


" Origami --------------------------------------------------------------------------------------------------------  {{{1
let g:OrigamiPadding = 4
let g:OrigamiFoldAtCol = 117
augroup Origami
  autocmd FileType c,cpp,systemverilog let g:OrigamiCommentString = '//%s'
augroup END


" Rainbow --------------------------------------------------------------------------------------------------------  {{{1
"let g:rainbow_active = 1
" augroup Rainbow
"   autocmd FileType c,cpp if exists('*rainbow#load')|call rainbow#load()|endif
" augroup END

" if &bg ==# 'dark'
"   let g:rainbow_guifgs   = [ 'OrangeRed1', 'LightGoldenRod1', 'DeepSkyBlue1', 'HotPink1', 'Chartreuse1', 'Yellow' ]
"   let g:rainbow_ctermfgs = [ 'Brown', 'DarkBlue', 'DarkGray', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta' ]
" else
"   let g:rainbow_guifgs = [ 'RoyalBlue3', 'DarkOrange3', 'SeaGreen3', 'DarkOrchid3', 'FireBrick3' ]
"   "let g:rainbow_guifgs   = ["#8a2be2" , "#ff69b4" , "#b294bb" , "#81a2be" , "#b5bd68" , "#ee6" , "#de935f" , "#c66" ]
" endif

" nnoremap coR :RainbowToggle<CR>


" Repeat ---------------------------------------------------------------------------------------------------------  {{{1
nnoremap <silent> <C-R> :<C-U>call repeat#wrap('U',v:count)<CR>
nnoremap <silent> U     :<C-U>call repeat#wrap("\<Lt>C-R>",v:count)<CR>


" Signature ------------------------------------------------------------------------------------------------------  {{{1
let g:SignatureMarkTextHLDynamic   = 1
let g:SignatureMarkerTextHLDynamic = 1
if exists('*signature#marker#Goto')
  for i in range(1,9)
    execute 'nnoremap <silent> ]' . i . ' :<C-U>call signature#marker#Goto("next", ' . i .', v:count)<CR>'
    execute 'nnoremap <silent> [' . i . ' :<C-U>call signature#marker#Goto("prev", ' . i .', v:count)<CR>'
  endfor
endif


" Sneak ----------------------------------------------------------------------------------------------------------  {{{1
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


" Submode --------------------------------------------------------------------------------------------------------  {{{1
let g:submode_always_show_submode = 1
let g:submode_keep_leaving_key    = 1

if exists('*submode#')
  call submode#enter_with( 'WinResize', 'n', '', '<C-W><'      , '<C-W><'       )
  call submode#enter_with( 'WinResize', 'n', '', '<C-W>>'      , '<C-W>>'       )
  call submode#map       ( 'WinResize', 'n', '', '<'           , '<C-W><'       )
  call submode#map       ( 'WinResize', 'n', '', '='           , '<C-W>='       )
  call submode#map       ( 'WinResize', 'n', '', '>'           , '<C-W>>'       )
  call submode#enter_with( 'WinResize', 'n', '', '<C-W>+'      , '<C-W>+'       )
  call submode#enter_with( 'WinResize', 'n', '', '<C-W>-'      , '<C-W>-'       )
  call submode#map       ( 'WinResize', 'n', '', '+'           , '<C-W>+'       )
  call submode#map       ( 'WinResize', 'n', '', '='           , '<C-W>='       )
  call submode#map       ( 'WinResize', 'n', '', '-'           , '<C-W>-'       )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>h'      , '<C-W>h'       )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>j'      , '<C-W>j'       )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>k'      , '<C-W>k'       )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W>l'      , '<C-W>l'       )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-H>'  , '<C-W><C-H>'   )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-J>'  , '<C-W><C-J>'   )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-K>'  , '<C-W><C-K>'   )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><C-L>'  , '<C-W><C-L>'   )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Up>'   , '<C-W><Up>'    )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Down>' , '<C-W><Down>'  )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Left>' , '<C-W><Left>'  )
  "call submode#enter_with( 'WinMove'  , 'n', '', '<C-W><Right>', '<C-W><Right>' )
  "call submode#map       ( 'WinMove'  , 'n', '', 'h'           , '<C-W>h'       )
  "call submode#map       ( 'WinMove'  , 'n', '', 'j'           , '<C-W>j'       )
  "call submode#map       ( 'WinMove'  , 'n', '', 'k'           , '<C-W>k'       )
  "call submode#map       ( 'WinMove'  , 'n', '', 'l'           , '<C-W>l'       )
  "call submode#map       ( 'WinMove'  , 'n', '', '<C-H>'       , '<C-W><C-H>'   )
  "call submode#map       ( 'WinMove'  , 'n', '', '<C-J>'       , '<C-W><C-J>'   )
  "call submode#map       ( 'WinMove'  , 'n', '', '<C-K>'       , '<C-W><C-K>'   )
  "call submode#map       ( 'WinMove'  , 'n', '', '<C-L>'       , '<C-W><C-L>'   )
  "call submode#map       ( 'WinMove'  , 'n', '', '<Up>'        , '<C-W><Up>'    )
  "call submode#map       ( 'WinMove'  , 'n', '', '<Down>'      , '<C-W><Down>'  )
  "call submode#map       ( 'WinMove'  , 'n', '', '<Left>'      , '<C-W><Left>'  )
  "call submode#map       ( 'WinMove'  , 'n', '', '<Right>'     , '<C-W><Right>' )
  "call submode#enter_with( 'Indent'   , 'n', '', '>>'          , '>>'           )
  "call submode#enter_with( 'Indent'   , 'n', '', '<<'          , '<<'           )
  "call submode#map       ( 'Indent'   , 'n', '', '>'           , '>>'           )
  "call submode#map       ( 'Indent'   , 'n', '', '<'           , '<<'           )
  "call submode#enter_with( 'WinCycle' , 'n', '', '<C-W><C-W>'  , '<C-W><C-W>'   )
  "call submode#enter_with( 'WinCycle' , 'n', '', '<C-W>w'      , '<C-W>w'       )
  "call submode#enter_with( 'WinCycle' , 'n', '', '<C-W>W'      , '<C-W>W'       )
  "call submode#map       ( 'WinCycle' , 'n', '', '<C-W>'       , '<C-W><C-W>'   )
  "call submode#map       ( 'WinCycle' , 'n', '', 'w'           , '<C-W>w'       )
  "call submode#map       ( 'WinCycle' , 'n', '', 'W'           , '<C-W>W'       )

  call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-N>',   '<Leader>m<C-N>')
  call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-P>',   '<Leader>m<C-P>')
  call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-A-N>', '<Leader>m<C-A-N>')
  call submode#enter_with('mark.vim', 'n', '', '<Leader>m<C-A-P>', '<Leader>m<C-A-P>')
  call submode#map       ('mark.vim', 'n', '', '<C-N>',            '<Leader>m<C-N>')
  call submode#map       ('mark.vim', 'n', '', '<C-P>',            '<Leader>m<C-P>')
  call submode#map       ('mark.vim', 'n', '', '<C-A-N>',          '<Leader>m<C-A-N>')
  call submode#map       ('mark.vim', 'n', '', '<C-A-P>',          '<Leader>m<C-A-P>')

  " Custom Maps
  "nnoremap <Plug>IncLines :<C-U>let &lines += 1<CR>
  "nnoremap <Plug>DecLines :<C-U>let &lines -= 1<CR>
  "call submode#enter_with( 'ResizeLines', 'n', 'r', '>l', '<Plug>IncLines' )
  "call submode#enter_with( 'ResizeLines', 'n', 'r', '<l', '<Plug>DecLines' )
  "call submode#map       ( 'ResizeLines', 'n', 'r', '>' , '<Plug>IncLines' )
  "call submode#map       ( 'ResizeLines', 'n', 'r', '<' , '<Plug>DecLines' )
  "nnoremap <Plug>IncColumns :<C-U>let &columns += 1<CR>
  "nnoremap <Plug>DecColumns :<C-U>let &columns -= 1<CR>
  "call submode#enter_with( 'ResizeColumns', 'n', 'r', '>c', '<Plug>IncColumns' )
  "call submode#enter_with( 'ResizeColumns', 'n', 'r', '<c', '<Plug>DecColumns' )
  "call submode#map       ( 'ResizeColumns', 'n', 'r', '>' , '<Plug>IncColumns' )
  "call submode#map       ( 'ResizeColumns', 'n', 'r', '<' , '<Plug>DecColumns' )
  "nnoremap <Plug>IncLineSpace :<C-U>let &linespace += 1<CR>
  "nnoremap <Plug>DecLineSpace :<C-U>let &linespace -= 1<CR>
  "call submode#enter_with( 'ResizeLsp', 'n', 'r', '>s', '<Plug>IncLineSpace' )
  "call submode#enter_with( 'ResizeLsp', 'n', 'r', '<s', '<Plug>DecLineSpace' )
  "call submode#map       ( 'ResizeLsp', 'n', 'r', '>' , '<Plug>IncLineSpace' )
  "call submode#map       ( 'ResizeLsp', 'n', 'r', '<' , '<Plug>DecLineSpace' )
  "nnoremap <Plug>IncFontSize :<C-U>IncFontSize<CR>
  "nnoremap <Plug>DecFontSize :<C-U>DecFontSize<CR>
  "call submode#enter_with( 'ResizeFont', 'n', 'r', '<f', '<Plug>DecFontSize' )
  "call submode#enter_with( 'ResizeFont', 'n', 'r', '>f', '<Plug>IncFontSize' )
  "call submode#map       ( 'ResizeFont', 'n', 'r', '<' , '<Plug>DecFontSize' )
  "call submode#map       ( 'ResizeFont', 'n', 'r', '>' , '<Plug>IncFontSize' )
endif


" Solarized ------------------------------------------------------------------------------------------------------  {{{1
let g:solarized_underline = 0
"let g:solarized_visibility = "high"


" Switch ---------------------------------------------------------------------------------------------------------  {{{1
nnoremap <BS> :Switch<CR>
let g:switch_mapping = ''
let g:switch_custom_definitions    = [
                                   \   [ 'TRUE', 'FALSE' ],
                                   \   [ 'pass', 'fail'  ],
                                   \   [ 'Pass', 'Fail'  ],
                                   \   [ 'PASS', 'FAIL'  ]
                                   \ ]


" TableMode ------------------------------------------------------------------------------------------------------  {{{1
let g:table_mode_map_prefix = '<Plug>[table]'
nnoremap coB :TableModeToggle<CR>


" Tabular --------------------------------------------------------------------------------------------------------  {{{1
" map     =t       <Plug>my(Tabular)
" noremap <silent> <Plug>my(Tabular)t       :Tabularize<Space>/
" noremap <silent> <Plug>my(Tabular)]       :Tabularize /\m]/l0r1<CR> //
" noremap <silent> <Plug>my(Tabular)<Bar>   :Tabularize /\|<CR>
" noremap <silent> <Plug>my(Tabular)(0      :Tabularize /\v^[^(]*\zs\(/l0r0<CR>
" noremap <silent> <Plug>my(Tabular)(1      :Tabularize /\v^[^(]*\zs\(/l0r1<CR>
" noremap <silent> <Plug>my(Tabular))0      :Tabularize /\v\)\ze[^)]*$/l0r0<CR>
" noremap <silent> <Plug>my(Tabular))1      :Tabularize /\v\)\ze[^)]*$/l1r0<CR>
" noremap <silent> <Plug>my(Tabular)b       :Tabularize align_braces<CR>
" noremap <silent> <Plug>my(Tabular),       :Tabularize /,/l0r1<CR>
" noremap <silent> <Plug>my(Tabular)=       :Tabularize assignment<CR>
" noremap <silent> <Plug>my(Tabular)?:      :Tabularize ternary_operator<CR>
" noremap <silent> <Plug>my(Tabular)/       :Tabularize trailing_c_comments<CR>
" noremap <silent> <Plug>my(Tabular)<Space> :Tabularize align_words<CR>


" vim-textobj-* --------------------------------------------------------------------------------------------------  {{{1
let g:textobj_comment_no_default_key_mappings    = 1
let g:textobj_function_no_default_key_mappings   = 1
let g:textobj_indent_no_default_key_mappings     = 1
let g:textobj_line_no_default_key_mappings       = 1
let g:textobj_space_no_default_key_mappings      = 1
let g:textobj_wordcolumn_no_default_key_mappings = 1

for s:mode in ['x', 'o']
  for s:motion in ['i', 'a']
    execute s:mode . 'map ' . s:motion . 'c       <Plug>(textobj-comment-'      . s:motion          . ')'
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


" Targets --------------------------------------------------------------------------------------------------------  {{{1
let g:targets_separators = ', . ; : + - = ~ * # / | \ & $'


" UltiSnips ------------------------------------------------------------------------------------------------------  {{{1
let g:UltiSnipsEditSplit = "vertical"
" Location of snippets
execute 'let g:UltiSnipsSnippetDirectories=["' . g:dotvim . '/UltiSnips"]'
" execute 'let g:UltiSnipsSnippetsDir="' . g:dotvim . '/UltiSnips"'
let g:UltiSnipsEnableSnipMate=0


" vim-vinegar ----------------------------------------------------------------------------------------------------  {{{1
nnoremap - <Plug>VinegarUp


" vim-wordmotion -------------------------------------------------------------------------------------------------  {{{1
let g:wordmotion_mappings = {
\ 'w': '<M-w>',
\ 'b': '<M-b>',
\ 'e': '<M-e>',
\ 'ge': 'g<M-e>',
\ 'aw': 'a<M-w>',
\ 'iw': 'i<M-w>'
\ }


" YouCompleteMe --------------------------------------------------------------------------------------------------  {{{1
let g:ycm_key_list_select_completion   = ['<C-N>']
let g:ycm_key_list_previous_completion = ['<C-P>']
