local map = vim.keymap.set

-- Leader and LocalLeader ----------------------------------------------------------------------------------------------
-- The leader is used for global maps and localleader for buffer/filetype specific maps
-- These need to be defined before the first map is called so they're defined in init.lua


--[[ Keymaps ]]---------------------------------------------------------------------------------------------------------
map('n', '<Leader>b', '<Plug>(leader-buffer-map)',  {remap=true, silent=true})
map('n', '<Leader>c', '<Plug>(leader-code-map)',    {remap=true, silent=true})
map('n', '<Leader>f', '<Plug>(leader-file-map)',    {remap=true, silent=true})
map('n', '<Leader>g', '<Plug>(leader-goto-map)',    {remap=true, silent=true})
map('n', '<Leader>h', '<Plug>(leader-help-map)',    {remap=true, silent=true})
map('n', '<Leader>o', '<Plug>(leader-open-map)',    {remap=true, silent=true})
map('n', '<Leader>p', '<Plug>(leader-project-map)', {remap=true, silent=true})
map('n', '<Leader>s', '<Plug>(leader-search-map)',  {remap=true, silent=true})
map('n', '<Leader>t', '<Plug>(leader-toggle-map)',  {remap=true, silent=true})
map('n', '<Leader>v', '<Plug>(leader-vcs-map)',     {remap=true, silent=true})
map('n', '<Leader>w', '<Plug>(leader-window-map)',  {remap=true, silent=true})


--[[ Buffers ]]---------------------------------------------------------------------------------------------------------
-- Switching buffers is something I do often so make that as fast as possible
map('n', '<Leader><Leader>', '<Plug>(leader-buffer-map)b', {remap=true, silent=true})


--[[ Remapping for convenience ]]---------------------------------------------------------------------------------------
-- Display full path and filename
map('n', '<C-G>', '2<C-G>')

-- Remap `ZQ` to quit everything. I can always use `:bd` to delete a single buffer
map('n', 'ZQ', '<Cmd>qall!<CR>')

-- Copy the file name to unix visual select buffer
map('n', '<Plug>(leader-file-map)y', function()
  vim.cmd('let @+="' .. vim.fn.expand('%:p') .. '"')
end, {desc="Copy file path"})


--[[ Files ------------------------------------------------------------------------------------------------------------
local fzf_lua_p4 = require('neovim-only.fzf-lua.perforce')

-- Checkout the file if in a VCS
map('n', '<Plug>(leader-vcs-map)e', function()
  if fzf_lua_p4.is_p4_repo({}, true) then
    vim.cmd "!p4 edit %"
  end
end, {desc = "Checkout file"})


map('n', '<Plug>(leader-vcs-map)f', function()
  if require('fzf-lua.path').is_git_repo({}, true) then
    return require('fzf-lua').git_files()
  elseif fzf_lua_p4.is_p4_repo({}, true) then
    return fzf_lua_p4.files()
  end
end, {desc="Find file"})


map('n', '<Plug>(leader-vcs-map)s', function()
  if require('fzf-lua.path').is_git_repo({}, true) then
    return require('fzf-lua').git_status()
  elseif fzf_lua_p4.is_p4_repo({}, true) then
    return fzf_lua_p4.status()
  end
end, {desc="Repo status"})
--]]


---[[ Misc -------------------------------------------------------------------------------------------------------------
map('n', '<Plug>(leader-open-map)m', '<Cmd>marks<CR>')
map('n', '<Plug>(leader-open-map)r', '<Cmd>reg<CR>')

map('n', '<Plug>(leader-toggle-map)l', function()
  if ((vim.fn.getloclist(0, { winid = 0 }).winid or 0) == 0) then
    vim.cmd "lopen"
  else
    vim.cmd "lclose"
  end
end, {desc = "Toggle LocationList"})


map('n', '<Plug>(leader-toggle-map)q', function()
  for _, win in pairs(vim.fn.getwininfo()) do
    if ((win.quickfix == 1) and (win.loclist == 0)) then
      vim.cmd('cclose')
      return
    end
  end
  vim.cmd('copen')
end, {desc = "Toggle QuickFix"})
