-- [[file:../../dotfiles/nvim.org::*Keybindings][Keybindings:2]]
local map = vim.keymap
-- Keybindings:2 ends here



-- Use Space as the leader key and create generic keymaps

-- [[file:../../dotfiles/nvim.org::*Keybindings][Keybindings:3]]
vim.g.mapleader = ' '
map.set('n', '<Leader>b', '<Plug>(leader-buffer-map)',  {remap=true, silent=true})
map.set('n', '<Leader>f', '<Plug>(leader-file-map)',    {remap=true, silent=true})
map.set('n', '<Leader>h', '<Plug>(leader-help-map)',    {remap=true, silent=true})
map.set('n', '<Leader>o', '<Plug>(leader-open-map)',    {remap=true, silent=true})
map.set('n', '<Leader>p', '<Plug>(leader-project-map)', {remap=true, silent=true})
map.set('n', '<Leader>s', '<Plug>(leader-search-map)',  {remap=true, silent=true})
map.set('n', '<Leader>t', '<Plug>(leader-toggle-map)',  {remap=true, silent=true})
map.set('n', '<Leader>v', '<Plug>(leader-vcs-map)',     {remap=true, silent=true})
-- Keybindings:3 ends here

-- [[file:../../dotfiles/nvim.org::*Keybindings][Keybindings:4]]
map.set('n', '<Plug>(leader-open-map)m', '<Cmd>marks<CR>')
map.set('n', '<Plug>(leader-open-map)r', '<Cmd>reg<CR>')
-- Keybindings:4 ends here

-- Remapping for convenience
-- Remap 'w' to behave as 'w' should in all cases ~:h cw~. Use =ce= to do what =cw= used to

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:1]]
map.set('o', 'w', 'v:count > 1 ? "<Cmd>normal! " . v:count . "w<CR>" : "<Cmd>normal! w<CR>"', {expr=true})
map.set('o', 'W', 'v:count > 1 ? "<Cmd>normal! " . v:count . "W<CR>" : "<Cmd>normal! W<CR>"', {expr=true})
-- Remapping for convenience:1 ends here



-- Display full path and filename

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:2]]
map.set('n', '<C-G>', '2<C-G>')
-- Remapping for convenience:2 ends here



-- Make Y consistent with C and D

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:3]]
map.set('n', 'Y', 'y$')
-- Remapping for convenience:3 ends here



-- Remap =ZQ= to quit everything. I can always use =:bd= to delete a single buffer

-- [[file:../../dotfiles/nvim.org::*Remapping for convenience][Remapping for convenience:4]]
map.set('n', 'ZQ', ':qall!<CR>')
-- Remapping for convenience:4 ends here

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

-- buffers
-- Switching buffers is something I do often so make that as fast as possible

-- [[file:../../dotfiles/nvim.org::*buffers][buffers:1]]
map.set('n', '<Leader><Leader>', '<Plug>(leader-buffer-map)b', {remap=true, silent=true})
-- buffers:1 ends here



-- Buffer navigation à la vim-unimpaired

-- [[file:../../dotfiles/nvim.org::*buffers][buffers:2]]
map.set('n', '[b', '<Cmd>bprevious<CR>')
map.set('n', ']b', '<Cmd>bnext<CR>')
-- buffers:2 ends here

-- files

-- [[file:../../dotfiles/nvim.org::*files][files:1]]
map.set('n', '<Leader>f', '<Plug>(leader-file-map)', {remap=true})
map.set('n', '<Leader>F', '<Plug>(leader-file-map)', {remap=true})
-- files:1 ends here



-- Checkout the file if in a VCS

-- [[file:../../dotfiles/nvim.org::*files][files:2]]
map.set('n', '<Plug>(leader-vcs-map)e', function()
    if require('fzf-lua.perforce').is_p4_repo({}, true) then
        vim.cmd "!p4 edit %"
    end
end, {desc = "Checkout file"})
-- files:2 ends here

map.set('n', '<Plug>(leader-toggle-map)l', function()
  if ((vim.fn.getloclist(0, { winid = 0 }).winid or 0) == 0) then
    vim.cmd "lopen"
  else
    vim.cmd "lclose"
  end
end, {desc = "Toggle LocationList"})

map.set('n', '<Plug>(leader-toggle-map)q', function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if ((win.quickfix == 1) and (win.loclist == 0)) then
            vim.cmd('cclose')
            return
        end
    end
    vim.cmd('copen')
end, {desc = "Toggle QuickFix"})
