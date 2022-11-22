local map = vim.keymap

-- Leader and LocalLeader ----------------------------------------------------------------------------------------------
-- The leader is used for global maps and localleader for buffer/filetype specific maps
-- These need to be defined before the first map is called so they're defined in init.lua


-- Default keymaps -----------------------------------------------------------------------------------------------------
map.set('n', '<Leader>b', '<Plug>(leader-buffer-map)',  {remap=true, silent=true})
map.set('n', '<Leader>f', '<Plug>(leader-file-map)',    {remap=true, silent=true})
map.set('n', '<Leader>h', '<Plug>(leader-help-map)',    {remap=true, silent=true})
map.set('n', '<Leader>o', '<Plug>(leader-open-map)',    {remap=true, silent=true})
map.set('n', '<Leader>p', '<Plug>(leader-project-map)', {remap=true, silent=true})
map.set('n', '<Leader>s', '<Plug>(leader-search-map)',  {remap=true, silent=true})
map.set('n', '<Leader>t', '<Plug>(leader-toggle-map)',  {remap=true, silent=true})
map.set('n', '<Leader>v', '<Plug>(leader-vcs-map)',     {remap=true, silent=true})

map.set('n', '<Plug>(leader-open-map)m', '<Cmd>marks<CR>')
map.set('n', '<Plug>(leader-open-map)r', '<Cmd>reg<CR>')


-- Remapping for convenience -------------------------------------------------------------------------------------------
-- Move by visual lines if count is not supplied. If a count is supplied then move by normal lines.
-- This makes it easy to supply a count to line-based operations such as yank/delete without worrying about visual lines
map.set({'n', 'v', 'o', 's', 'x'}, 'j', "v:count == 0 ? 'gj' : 'j'", {expr=true})
map.set({'n', 'v', 'o', 's', 'x'}, 'gj', 'j')
map.set({'n', 'v', 'o', 's', 'x'}, 'k', "v:count == 0 ? 'gk' : 'k'", {expr=true})
map.set({'n', 'v', 'o', 's', 'x'}, 'gk', 'k')

-- Swap 'U' and 'C-R'
map.set('n', '<C-R>', 'U', {silent=true})
map.set('n', 'U',     '<C-R>', {silent=true})

-- Remap 'w' to behave as 'w' should in all cases (:h cw). Use `ce` to do what `cw` used to
map.set('o', 'w', 'v:count > 1 ? "<Cmd>normal! " . v:count . "w<CR>" : "<Cmd>normal! w<CR>"', {expr=true})
map.set('o', 'W', 'v:count > 1 ? "<Cmd>normal! " . v:count . "W<CR>" : "<Cmd>normal! W<CR>"', {expr=true})

-- Display full path and filename
map.set('n', '<C-G>', '2<C-G>')

-- Remap `ZQ` to quit everything. I can always use `:bd` to delete a single buffer
map.set('n', 'ZQ', '<Cmd>qall!<CR>')

-- Copy the file name to unix visual select buffer
map.set('n', 'y<C-G>', function()
  vim.cmd('let @+="' .. vim.fn.expand('%:p') .. '"')
end, {desc="Copy file path"})


-- Indentation and styling ---------------------------------------------------------------------------------------------
-- Preserve visual block after indenting, increment/decrement
map.set('v', '>',     '>gv')
map.set('v', '<',     '<gv')
map.set('v', '<C-A>', '<C-A>gv')
map.set('v', '<C-X>', '<C-X>gv')

-- FIXME Search and Replace

-- Use very-magic (PCRE-ish) while searching
map.set('n', '/',   '/\\v')
map.set('n', '?',   '?\\v')
map.set('c', '%s/', '%s/\\v')
map.set('c', '.s/', '.s/\\v')
map.set('x', ':s/', ':s/\\%V\\v')

-- Replace word under the cursor. Type replacement, press `<ESC>`. Use `.` to jump to next occurence and repeat
map.set('n', 'c*',  '*<C-O>cgn')
map.set('n', 'cg*', 'g*<C-O>cgn')


-- buffers -------------------------------------------------------------------------------------------------------------
-- Switching buffers is something I do often so make that as fast as possible
map.set('n', '<Leader><Leader>', '<Plug>(leader-buffer-map)b', {remap=true, silent=true})

-- Buffer navigation à la vim-unimpaired
map.set('n', '[b', '<Cmd>bprevious<CR>')
map.set('n', ']b', '<Cmd>bnext<CR>')


-- files ---------------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>f', '<Plug>(leader-file-map)', {remap=true})
map.set('n', '<Leader>F', '<Plug>(leader-file-map)', {remap=true})


-- Checkout the file if in a VCS
map.set('n', '<Plug>(leader-vcs-map)e', function()
  if require('fzf-lua.perforce').is_p4_repo({}, true) then
    vim.cmd "!p4 edit %"
  end
end, {desc = "Checkout file"})


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


map.set('n', '<Plug>(leader-vcs-map)f', function()
  if require('fzf-lua.path').is_git_repo({}, true) then
    return require('fzf-lua').git_files()
  elseif require('fzf-lua.perforce').is_p4_repo({}, true) then
    return require('fzf-lua.perforce').files()
  end
end, {desc="Find file"})


map.set('n', '<Plug>(leader-vcs-map)F', function()
  if require('fzf-lua.path').is_git_repo({cwd='.'}, true) then
    return require('fzf-lua').git_files({cwd='.'})
  elseif require('fzf-lua.perforce').is_p4_repo({cwd='.'}, true) then
    return require('fzf-lua.perforce').files({cwd='.'})
  end
end, {desc="Find file from here"})


map.set('n', '<Plug>(leader-vcs-map)s', function()
  if require('fzf-lua.path').is_git_repo({}, true) then
    return require('fzf-lua').git_status()
  elseif require('fzf-lua.perforce').is_p4_repo({}, true) then
    return require('fzf-lua.perforce').status()
  end
end, {desc="Repo status"})


map.set('n', '<Plug>(leader-project-map)f', function()
  if require('fzf-lua.path').is_git_repo({}, true) then
    return require('fzf-lua').git_files()
  elseif require('fzf-lua.perforce').is_p4_repo({}, true) then
    return require('fzf-lua.perforce').files()
  else
    return require('fzf-lua').files()
  end
end, {desc="Find file"})


map.set('n', '<Plug>(leader-project-map)F', function()
  if require('fzf-lua.path').is_git_repo({cwd='.'}, true) then
    return require('fzf-lua').git_files({cwd='.'})
  elseif require('fzf-lua.perforce').is_p4_repo({cwd='.'}, true) then
    return require('fzf-lua.perforce').files({cwd='.'})
  else
    return require('fzf-lua').files({cwd='.'})
  end
end, {desc="Find file from here"})


-- Fill Text Width
map.set('n', '<Leader>mf', "<Cmd>call utils#FillTW()<CR>", {silent=true})
