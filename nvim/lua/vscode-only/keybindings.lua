local map = vim.keymap

-- [[ Leader ]]---------------------------------------------------------------------------------------------------------
-- The leader is used for global maps.
-- It needs to be defined before the first map is called so it's defined in init.lua

local mapL = function(key, cmd)
  map.set('n', '<Leader>' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

mapL('<Leader>', 'workbench.action.quickOpenWithModes')         -- Ctrl+P with more info
mapL(';', 'workbench.action.quickOpenView')
mapL(':', 'workbench.action.showCommands')                      -- Ctrl+Shift+P
-- mapL('`', 'workbench.action.quickOpenPreviousRecentlyUsedEditor')
-- mapL(',', 'workbench.action.showAllEditorsByMostRecentlyUsed')
mapL('<Tab>', 'workbench.action.showAllEditors')


-- [[ LocalLeader ]]----------------------------------------------------------------------------------------------------
-- The localleader is used for mode/filetype specific maps
-- It needs to be defined before the first map is called so it's defined in init.lua

local mapLL = function(key, cmd)
  map.set('n', '<LocalLeader>' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end
mapLL('<LocalLeader>', 'workbench.action.quickOpenRecent')


--[[ Editors ]]---------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>b', '<Plug>(leader-editor-map)', {remap=true, silent=true})
local mapb = function(key, cmd)
  map.set('n', '<Plug>(leader-editor-map)' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

-- mapb('a', 'workbench.action.showAllEditorsByMostRecentlyUsed')
mapb('b', 'workbench.action.showEditorsInActiveGroup')
mapb('B', 'workbench.action.showAllEditors')
mapb('c', 'workbench.action.closeActiveEditor')
mapb('C', 'workbench.action.closeEditorInAllGroups')
mapb('d', 'workbench.action.closeEditorsInGroup')  --  except pinned
mapb('D', 'workbench.action.closeAllEditors')
mapb('H', 'workbench.action.moveEditorLeftInGroup')
mapb('J', 'workbench.action.moveEditorToLastGroup')
mapb('K', 'workbench.action.moveEditorToFirstGroup')
mapb('L', 'workbench.action.moveEditorRightInGroup')
mapb('n', 'workbench.action.nextEditorInGroup')
mapb('N', 'workbench.action.moveEditorToNextGroup')
mapb('o', 'workbench.action.closeOtherEditors')
mapb('p', 'workbench.action.previousEditorInGroup')
mapb('P', 'workbench.action.moveEditorToPreviousGroup')
mapb('r', 'workbench.action.closeUnmodifiedEditors')
mapb('R', 'workbench.action.files.revert')
mapb('s', 'workbench.action.toggleSplitEditorInGroup')
mapb('S', 'workbench.action.toggleSplitEditorInGroupLayout')
mapb('u', 'workbench.action.reopenClosedEditor')
mapb('x', 'workbench.action.pinEditor')
mapb('X', 'workbench.action.unpinEditor')
mapb('y', 'copyFilePath')
-- mapb('`', 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')


--[[ Editor-groups ]]---------------------------------------------------------------------------------------------------
map.set('n', '<Leader>w', '<Plug>(leader-editor-group-map)', {remap=true, silent=true})
local mapw = function(key, cmd)
  map.set('n', '<Plug>(leader-editor-group-map)' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

mapw('c',  'workbench.action.closeGroup')
mapw('C',  'workbench.action.closeAllGroups')
mapw('h',  'workbench.action.focusLeftGroup')
mapw('j',  'workbench.action.focusBelowGroup')
mapw('k',  'workbench.action.focusAboveGroup')
mapw('l',  'workbench.action.focusRightGroup')
mapw('H',  'workbench.action.moveActiveEditorGroupLeft')
mapw('J',  'workbench.action.moveActiveEditorGroupDown')
mapw('K',  'workbench.action.moveActiveEditorGroupUp')
mapw('L',  'workbench.action.moveActiveEditorGroupRight')
mapw('o',  'workbench.action.closeEditorsInOtherGroups')
mapw('nh', 'workbench.action.newGroupLeft')
mapw('nj', 'workbench.action.newGroupDown')
mapw('nk', 'workbench.action.newGroupUp')
mapw('nl', 'workbench.action.newGroupRight')
mapw('u',  'workbench.action.joinAllGroups')
mapw('w',  'workbench.action.navigateEditorGroups')
mapw('z',  'workbench.action.toggleEditorWidths')
mapw('Z',  'workbench.action.maximizeEditor')
mapw('=',  'workbench.action.evenEditorWidths')


--[[ Help ]]------------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>h', '<Plug>(leader-help-map)',    {remap=true, silent=true})
local maph = function(key, cmd)
  map.set('n', '<Plug>(leader-help-map)' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

maph('b', 'workbench.action.openGlobalKeybindings')
maph('B', 'workbench.action.openDefaultKeybindingsFile')
maph('t', 'workbench.action.selectTheme')
maph(',', 'workbench.action.openSettings')


--[[ Projects/Folders/Workspaces ]]-------------------------------------------------------------------------------------
map.set('n', '<Leader>p', '<Plug>(leader-project-map)',  {remap=true, silent=true})
local mapp = function(key, cmd)
  map.set('n', '<Plug>(leader-project-map)' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

mapp('p', 'workbench.action.openRecent')


--[[ Search ]]----------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>s', '<Plug>(leader-search-map)', {remap=true, silent=true})
local maps = function(key, cmd)
  map.set('n', '<Plug>(leader-search-map)' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

maps('o', 'workbench.action.gotoSymbol')
maps('O', 'workbench.action.showAllSymbols')


--[[ Toggle ]]----------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>t', '<Plug>(leader-toggle-map)',  {remap=true, silent=true})
local mapt = function(key, cmd)
  map.set('n', '<Plug>(leader-toggle-map)' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

mapt('b', 'workbench.action.toggleSidebarVisibility')
mapt('B', 'workbench.action.toggleAuxiliaryBar')
mapt('e', 'workbench.action.toggleCenteredLayout')
-- mapt('n', 'settings.cycle.lineNumbers')
mapt('p', 'workbench.action.togglePanel')
mapt('P', 'workbench.action.toggleMaximizedPanel')
mapt('t', 'workbench.action.toggleLightDarkThemes')
mapt('w', 'editor.action.toggleWordWrap')
mapt('z', 'workbench.action.toggleZenMode')
mapt('_', 'workbench.action.toggleMenuBar')
mapt('>', 'breadcrumbs.toggle')
mapt('<Tab>', 'workbench.action.toggleTabsVisibility')


--[[ VCS ]]----------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>v', '<Plug>(leader-vcs-map)', {remap=true, silent=true})
local maps = function(key, cmd)
  map.set('n', '<Plug>(leader-vcs-map)' .. key, '<Cmd>call VSCodeCall("' .. cmd .. '", 1)<CR>', {remap=true})
end

maps('a', 'perforce.annotate')
maps('d', 'perforce.diff')
maps('e', 'perforce.edit')
maps('e', 'perforce.opened')


--[[ Extensions ]]------------------------------------------------------------------------------------------------------
-- Commentary
map.set({'n', 'o', 'x'}, 'gc', '<Plug>VSCodeCommentary', {remap=true})
map.set('n', 'gcc', '<Plug>VSCodeCommentaryLine', {remap=true})
