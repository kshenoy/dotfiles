-- Neovim already has a lot of sane defaults. Here's some more.
-- The options are arranged according to how they're specified in 'options.txt'
local opt = vim.opt


-- Moving around, searching and patterns -------------------------------------------------------------------------------
opt.autochdir  = true                                                              -- change directory to file in window
opt.ignorecase = true
opt.smartcase  = true                                          -- ignore 'ignorecase' if search has uppercase characters


-- Tags ----------------------------------------------------------------------------------------------------------------
opt.tags = "./tags;,./.tags;"


-- Displaying text -----------------------------------------------------------------------------------------------------
opt.scrolloff     = 3                                              -- no. of lines to show around the cursor for context
opt.showbreak     = "↪"                                                 -- string to put at the start of wrapped lines
opt.sidescroll    = 3                                                -- minimal number of columns to scroll horizontally
opt.sidescrolloff = 10                                           -- no. of columns to show around the cursor for context
opt.cmdheight     = 2          -- number of screen lines to use for the command-line. Helps avoiding 'hit-enter' prompts
opt.list          = true                                                             -- make it easier to see whitespace
opt.listchars     = {tab='➤ ', extends='»', precedes='«', nbsp='˽', trail='…'}
opt.conceallevel  = 2
opt.concealcursor = "nc"


-- Syntax, highlighting and spelling -----------------------------------------------------------------------------------
opt.termguicolors = true                                                           -- enable 24-bit RGB color in the TUI
opt.cursorline    = true                                                      -- highlight the screen line of the cursor
opt.colorcolumn   = "+1"                                                           -- highlight Column 121 (textwidth+1)


-- Multiple windows, tab pages -----------------------------------------------------------------------------------------
opt.laststatus = 3                                                                           -- enable global statusline
opt.splitbelow = true
opt.splitright = true


-- Using the mouse -----------------------------------------------------------------------------------------------------
opt.mouse = "ar"                                                                               -- use mouse in all modes


-- Selecting text ------------------------------------------------------------------------------------------------------
opt.clipboard = "unnamed"                          -- use the * register for all yank, delete, change and put operations


-- Editing text --------------------------------------------------------------------------------------------------------
opt.undofile  = true
opt.textwidth = 120
opt.completeopt:append('noinsert')                               -- do not insert any text for a match until I select it
opt.completeopt:append('noselect')                                    -- do not select a match in the menu automatically
opt.showmatch  = true                                                                          -- show matching brackets


-- Tabs and indenting --------------------------------------------------------------------------------------------------
opt.expandtab   = true
opt.shiftwidth  = 2
opt.softtabstop = -1                                                                        -- Use value from shiftwidth
opt.shiftround  = true


-- Reading and writing files, swap file --------------------------------------------------------------------------------
opt.backup   = true
opt.backupdir:remove(".")
opt.swapfile = false


-- Command line editing ------------------------------------------------------------------------------------------------
opt.suffixes:remove(".h")                                                            -- always show all .h files with :e
opt.wildmode = "longest:full,full"           -- insert longest match and show a menu of completions upon first Tab-press
                                             -- cycle through possible matches with consecutive Tab-presses


-- Running make and jumping to errors (quickfix) -----------------------------------------------------------------------
if (vim.fn.executable('rg')) then
    opt.grepformat = "%f:%l:%m"
    opt.grepprg    = "rg --vimgrep --smart-case"
end
