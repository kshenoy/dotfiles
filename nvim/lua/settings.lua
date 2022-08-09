

-- Neovim already has a lot of sane defaults. Here's some more.
-- The options are arranged according to how they're specified in 'options.txt'

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:2]]
local opt = vim.opt
-- Settings:2 ends here



-- Moving around, searching and patterns

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:3]]
opt.autochdir  = true    -- change directory to file in window
opt.ignorecase = true
opt.smartcase  = true    -- ignore 'ignorecase' if search has uppercase characters
-- Settings:3 ends here



-- Tags

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:4]]
opt.tags = "./tags;,./.tags;"
-- Settings:4 ends here



-- Displaying text

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:5]]
opt.scrolloff     = 3        -- no. of lines to show around the cursor for context
opt.showbreak     = "↪"     -- string to put at the start of wrapped lines
opt.sidescroll    = 3        -- minimal number of columns to scroll horizontally
opt.sidescrolloff = 10       -- no. of columns to show around the cursor for context
opt.cmdheight     = 2        -- number of screen lines to use for the command-line. Helps avoiding 'hit-enter' prompts
opt.list          = true     -- make it easier to see whitespace
opt.listchars     = {tab='➤ ', extends='»', precedes='«', nbsp='˽', trail='…'}
opt.conceallevel  = 2
opt.concealcursor = "nc"
-- Settings:5 ends here



-- Syntax, highlighting and spelling

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:6]]
opt.termguicolors = true    -- enable 24-bit RGB color in the TUI
opt.cursorline    = true    -- highlight the screen line of the cursor
opt.colorcolumn   = "+1"    -- highlight Column 121 (textwidth+1)
-- Settings:6 ends here



-- Multiple windows, tab pages

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:7]]
opt.laststatus = 3       -- enable global statusline

opt.splitbelow = true
opt.splitright = true
-- Settings:7 ends here



-- Using the mouse

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:8]]
opt.mouse = "ar"    -- use mouse in all modes
-- Settings:8 ends here



-- Selecting text

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:9]]
opt.clipboard = "unnamed"    -- use the * register for all yank, delete, change and put operations
-- Settings:9 ends here



-- Editing text

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:10]]
opt.undofile  = true
opt.textwidth = 120
opt.completeopt:append('noinsert')    -- do not insert any text for a match until I select it
opt.completeopt:append('noselect')    -- do not select a match in the menu automatically
opt.showmatch  = true                 -- show matching brackets
-- Settings:10 ends here



-- Tabs and indenting

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:11]]
opt.expandtab   = true
opt.shiftwidth  = 2
opt.softtabstop = -1  -- Use value from shiftwidth
opt.shiftround  = true
-- Settings:11 ends here



-- Reading and writing files, swap file

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:12]]
opt.backup   = true
opt.backupdir:remove(".")
opt.swapfile = false
-- Settings:12 ends here



-- Command line editing

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:13]]
opt.suffixes:remove(".h")             -- always show all .h files with :e
opt.wildmode = "longest:full,full"    -- insert longest match and show a menu of completions upon first Tab-press
                                      -- cycle through possible matches with consecutive Tab-presses
-- Settings:13 ends here



-- Running make and jumping to errors (quickfix)

-- [[file:../../dotfiles/nvim.org::*Settings][Settings:14]]
if (vim.fn.executable('rg')) then
    opt.grepformat = "%f:%l:%m"
    opt.grepprg    = "rg --vimgrep --smart-case"
end
-- Settings:14 ends here
