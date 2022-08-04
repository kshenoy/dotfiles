-- Settings
-- Neovim already has a lot of sane defaults. Here's some more.
-- The options are arranged according to how they're specified in 'options.txt'

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:1]]
local opt = vim.opt
-- Settings:1 ends here



-- Moving around, searching and patterns

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:2]]
opt.autochdir  = true    -- change directory to file in window
opt.ignorecase = true
opt.smartcase  = true    -- ignore 'ignorecase' if search has uppercase characters
-- Settings:2 ends here



-- Tags

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:3]]
opt.tags = "./tags;,./.tags;"
-- Settings:3 ends here



-- Displaying text

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:4]]
opt.scrolloff     = 3        -- no. of lines to show around the cursor for context
opt.showbreak     = "↪"     -- string to put at the start of wrapped lines
opt.sidescroll    = 3        -- minimal number of columns to scroll horizontally
opt.sidescrolloff = 10       -- no. of columns to show around the cursor for context
opt.cmdheight     = 2        -- number of screen lines to use for the command-line. Helps avoiding 'hit-enter' prompts
opt.list          = true     -- make it easier to see whitespace
opt.listchars     = {tab='➤ ', extends='»', precedes='«', nbsp='˽', trail='…'}
opt.conceallevel  = 2
opt.concealcursor = "nc"
-- Settings:4 ends here



-- Syntax, highlighting and spelling

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:5]]
opt.termguicolors = true    -- enable 24-bit RGB color in the TUI
opt.cursorline    = true    -- highlight the screen line of the cursor
opt.colorcolumn   = "+1"    -- highlight Column 121 (textwidth+1)
-- Settings:5 ends here



-- Multiple windows, tab pages

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:6]]
opt.laststatus = 3       -- enable global statusline

opt.splitbelow = true
opt.splitright = true
-- Settings:6 ends here



-- Using the mouse

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:7]]
opt.mouse = "ar"    -- use mouse in all modes
-- Settings:7 ends here



-- Selecting text

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:8]]
opt.clipboard = "unnamed"    -- use the * register for all yank, delete, change and put operations
-- Settings:8 ends here



-- Editing text

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:9]]
opt.undofile  = true
opt.textwidth = 120
opt.completeopt:append('noinsert')    -- do not insert any text for a match until I select it
opt.completeopt:append('noselect')    -- do not select a match in the menu automatically
opt.showmatch  = true                 -- show matching brackets
-- Settings:9 ends here



-- Tabs and indenting

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:10]]
opt.expandtab   = true
opt.shiftwidth  = 2
opt.softtabstop = -1  -- Use value from shiftwidth
opt.shiftround  = true
-- Settings:10 ends here



-- Reading and writing files, swap file

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:11]]
opt.backup   = true
opt.backupdir:remove(".")
opt.swapfile = false
-- Settings:11 ends here



-- Command line editing

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:12]]
opt.suffixes:remove(".h")             -- always show all .h files with :e
opt.wildmode = "longest:full,full"    -- insert longest match and show a menu of completions upon first Tab-press
                                      -- cycle through possible matches with consecutive Tab-presses
-- Settings:12 ends here



-- Running make and jumping to errors (quickfix)

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:13]]
if (vim.fn.executable('rg')) then
    opt.grepformat = "%f:%l:%m"
    opt.grepprg    = "rg --vimgrep --smart-case"
end
-- Settings:13 ends here

-- Keybindings

-- [[file:../../dotfiles/nvim.org::*Keybindings][Keybindings:1]]

-- Keybindings:1 ends here

-- [[file:../../dotfiles/nvim.org::*Keybindings][Keybindings:2]]
local map = vim.keymap
-- Keybindings:2 ends here



-- Use Space as the leader key

-- [[file:../../dotfiles/nvim.org::*Keybindings][Keybindings:3]]
vim.g.mapleader = ' '
-- Keybindings:3 ends here

-- Remapping for convenience

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:1]]
map.set('n', '<Leader>sm', ':marks<CR>')
map.set('n', '<Leader>sr', ':reg<CR>')
-- Remapping for convenience:1 ends here



-- Remap 'w' to behave as 'w' should in all cases ~:h cw~. Use =ce= to do what =cw= used to

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:2]]
map.set('o', 'w', 'v:count > 1 ? ":normal! " . v:count . "w<CR>" : ":normal! w<CR>"', {expr=true})
map.set('o', 'W', 'v:count > 1 ? ":normal! " . v:count . "W<CR>" : ":normal! W<CR>"', {expr=true})
-- Remapping for convenience:2 ends here



-- Display full path and filename

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:3]]
map.set('n', '<C-G>', '2<C-G>')
-- Remapping for convenience:3 ends here



-- Make Y consistent with C and D

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:4]]
map.set('n', 'Y', 'y$')
-- Remapping for convenience:4 ends here



-- Remap =ZQ= to quit everything. I can always use =:bd= to delete a single buffer

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:5]]
map.set('n', 'ZQ', ':qall!<CR>')
-- Remapping for convenience:5 ends here

-- Indentation and styling
-- Preserve visual block after indenting, increment/decrement

-- [[file:../../dotfiles/nvim.org::*Indentation and styling][Indentation and styling:1]]
map.set('v', '>',     '>gv')
map.set('v', '<',     '<gv')
map.set('v', '<C-A>', '<C-A>gv')
map.set('v', '<C-X>', '<C-X>gv')
-- Indentation and styling:1 ends here

-- FIXME Search and Replace
-- Use very-magic (PCRE-ish) while searching

-- [[file:../../dotfiles/nvim.org::*Search and Replace][Search and Replace:1]]
map.set('n', '/',   '/\\v')
map.set('n', '?',   '?\\v')
map.set('c', '%s/', '%s/\\v')
map.set('c', '.s/', '.s/\\v')
map.set('x', ':s/', ':s/\\%V\\v')
-- Search and Replace:1 ends here



-- Replace word under the cursor. Type replacement, press =<ESC>=. Use '.' to jump to next occurence of the word and repeat

-- [[file:../../dotfiles/nvim.org::*Search and Replace][Search and Replace:4]]
map.set('n', 'c*',  '*<C-O>cgn')
map.set('n', 'cg*', 'g*<C-O>cgn')
-- Search and Replace:4 ends here

-- Make pretty
-- Automatically load the same base16 theme as the shell

-- [[file:../../dotfiles/nvim.org::*Make pretty][Make pretty:1]]
vim.api.nvim_create_autocmd({"VimEnter", "FocusGained"}, {
  desc = "Automatically load the same base16 theme as the shell",
  callback = function()
    vim.cmd "if filereadable(expand('~/.vimrc_background')) | silent! source ~/.vimrc_background | endif"
  end,
  nested = true  -- required to trigger the Colorscheme autocmd to make any tweaks to the colorscheme
})
-- Make pretty:1 ends here



-- Tweak solarized-light theme

-- [[file:../../dotfiles/nvim.org::*Make pretty][Make pretty:2]]
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'base16-solarized-light',
  callback = function()
    vim.api.nvim_set_hl(0, 'StatusLine', {link='LineNr'})
    -- Need to update StatusLineNC's bg color
  end
})
-- Make pretty:2 ends here

-- [[file:../../dotfiles/nvim.org::*Fzf][Fzf:2]]
map.set('n', '<Leader>bb', ':FzfLua buffers<CR>')
-- Fzf:2 ends here
