local map = vim.keymap

-- TODO: Change leader from 'Space' to 'Ctrl+Space' to allow using it in Insert mode
-- TODO: Change localleader from '\' to 'Ctrl+\' to allow using it in Insert mode
-- TODO: Use settings.cycler to replace multiple commands with a single toggle eg. pin/unpin etc.


-- map.set('n', 'z=', '<Cmd>call VSCodeNotify("workbench.action.toggleSidebarVisibility")<CR>', {remap=true})


-- [[ LEADER ]]---------------------------------------------------------------------------------------------------------
-- The leader is used for global maps.
-- It needs to be defined before the first map is called so it's defined in init.lua

local mapL = function(key, cmd)
  map.set('n', '<Leader>' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

mapL('<Leader>', 'workbench.action.quickOpenWithModes')                                         -- Ctrl+P with more info
mapL(':', 'workbench.action.showCommands')                                                               -- Ctrl+Shift+P
-- mapL('`', 'workbench.action.quickOpenPreviousRecentlyUsedEditor')
-- mapL(',', 'workbench.action.showAllEditorsByMostRecentlyUsed')
mapL('<Tab>', 'workbench.action.showAllEditors')


-- [[ LOCAL-LEADER ]]---------------------------------------------------------------------------------------------------
-- The localleader is used for mode/filetype specific maps
-- It needs to be defined before the first map is called so it's defined in init.lua

local mapLL = function(key, cmd)
  map.set('n', '<LocalLeader>' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end
-- mapLL('<LocalLeader>', 'editor.action.goToDeclaration')


--[[ EDITORS ]]---------------------------------------------------------------------------------------------------------
-- Bindings related to the editor (buffer)
map.set('n', '<Leader>b', '<Plug>(leader-editor-map)', {remap=true, silent=true})
local mapb = function(key, cmd)
  map.set('n', '<Plug>(leader-editor-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

-- mapb('a', 'workbench.action.showAllEditorsByMostRecentlyUsed')
mapb('b',       'workbench.action.showEditorsInActiveGroup')
mapb('B',       'workbench.action.showAllEditors')
mapb('c',       'workbench.action.closeActiveEditor')
mapb('C',       'workbench.action.closeEditorInAllGroups')
mapb('<M-c>',   'workbench.action.closeEditorsInGroup')                                              --  (except pinned)
mapb('<M-S-C>', 'workbench.action.closeAllEditors')
mapb('d',       'workbench.action.closeUnmodifiedEditors')
mapb('H',       'workbench.action.moveEditorLeftInGroup')
mapb('J',       'workbench.action.moveEditorToLastGroup')
mapb('K',       'workbench.action.moveEditorToFirstGroup')
mapb('L',       'workbench.action.moveEditorRightInGroup')
mapb('n',       'workbench.action.nextEditorInGroup')
mapb('N',       'workbench.action.moveEditorToNextGroup')
mapb('o',       'workbench.action.closeOtherEditors')
mapb('p',       'workbench.action.previousEditorInGroup')
mapb('P',       'workbench.action.moveEditorToPreviousGroup')
mapb('r',       'workbench.action.files.revert')
mapb('s',       'workbench.action.toggleSplitEditorInGroup')
mapb('S',       'workbench.action.toggleSplitEditorInGroupLayout')
mapb('u',       'workbench.action.reopenClosedEditor')                                                  --  (u)ndo close
mapb('x',       'workbench.action.pinEditor')
mapb('X',       'workbench.action.unpinEditor')
mapb('y',       'copyFilePath')                                                  -- (y)ank file-path. doom also uses 'y'
-- mapb('`', 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')


--[[ EDITOR-GROUPS ]]---------------------------------------------------------------------------------------------------
-- Bindings related to the editor-group (window)
map.set('n', '<Leader>w', '<Plug>(leader-editor-group-map)', {remap=true, silent=true})
local mapw = function(key, cmd)
  map.set('n', '<Plug>(leader-editor-group-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
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
mapw('u',  'workbench.action.joinAllGroups')                                                      --  (u)nite all groups
mapw('w',  'workbench.action.navigateEditorGroups')
mapw('z',  'workbench.action.toggleEditorWidths')                                        --  (z)oom in/out or maximi(z)e
mapw('Z',  'workbench.action.maximizeEditor')                                  --  like zoom but gets rid of Primary Bar
mapw('=',  'workbench.action.evenEditorWidths')


--[[ CODE ]]------------------------------------------------------------------------------------------------------------
-- Bindings that act upon or affect the code
map.set('n', '<Leader>c', '<Plug>(leader-code-map)', {remap=true, silent=true})
local mapc = function(key, cmd)
  map.set('n', '<Plug>(leader-code-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

mapc('r', 'editor.action.rename')


--[[ GO TO ]]-----------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>g', '<Plug>(leader-goto-map)', {remap=true, silent=true})
local maps = function(key, cmd)
  map.set('n', '<Plug>(leader-goto-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

-- General pattern followed in defining these bindings
--   (d)efinitions, (h)ierarchy, (i)mplementation, symb(o)l, (r)eferences, (t)ypes
-- These are then combined with modifiers to specify how it should be shown
--   Ctrl   : Peek at something. Control what's shown
--   Alt    : Show all of something
--   Ctrl+W : Open on the side

maps('d',      'editor.action.revealDefinition')
maps('<C-W>d', 'editor.action.revealDefinitionAside')
maps('<C-D>',  'editor.action.peekDefinition')

maps('h',      'references-view.showCallHierarchy')

maps('o',      'workbench.action.gotoSymbol')
maps('O',      'workbench.action.showAllSymbols')

maps('r',      'editor.action.goToReferences')
maps('<C-R>',  'editor.action.referenceSearch.trigger')
maps('<M-r>',  'references-view.findReferences')
maps('<C-W>r', 'openReferenceToSide')

-- maps('q', 'editor.action.revealDeclaration')
-- maps('<C->', 'editor.action.peekDeclaration')
-- maps('<C-W>', 'editor.action.openDeclarationToTheSide')
-- editor.action.previewDeclaration


--[[ HELP ]]------------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>h', '<Plug>(leader-help-map)', {remap=true, silent=true})
local maph = function(key, cmd)
  map.set('n', '<Plug>(leader-help-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

maph('b', 'workbench.action.openGlobalKeybindings')
maph('B', 'workbench.action.openDefaultKeybindingsFile')


--[[ KUSTOMIZE ]]-------------------------------------------------------------------------------------------------------
-- Bindings related to the VSCode application. VSCode seems to use Ctrl+K a lot
map.set('n', '<Leader>k', '<Plug>(leader-kustom-map)', {remap=true, silent=true})
local mapk = function(key, cmd)
  map.set('n', '<Plug>(leader-kustom-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

mapk('b', 'workbench.files.action.focusOpenEditorsView')
mapk('f', 'workbench.explorer.fileView.focus')
mapk('o', 'outline.focus')
mapk('t', 'workbench.action.selectTheme')
mapk('x', 'workbench.view.extensions')
mapk(',', 'workbench.action.openSettings')

-- Menu-like behavior use M- maps
mapk('<C-v>', 'workbench.action.quickOpenView')
mapk('<C-l>', 'workbench.action.customizeLayout')


--[[ PROJECTS/FOLDERS/WORKSPACES ]]-------------------------------------------------------------------------------------
map.set('n', '<Leader>p', '<Plug>(leader-project-map)', {remap=true, silent=true})
local mapp = function(key, cmd)
  map.set('n', '<Plug>(leader-project-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

mapp('p', 'workbench.action.openRecent')


--[[ SEARCH ]]----------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>s', '<Plug>(leader-search-map)', {remap=true, silent=true})
local maps = function(key, cmd)
  map.set('n', '<Plug>(leader-search-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end


--[[ TOGGLE ]]----------------------------------------------------------------------------------------------------------
map.set('n', '<Leader>t', '<Plug>(leader-toggle-map)', {remap=true, silent=true})
local mapt = function(key, cmd)
  map.set('n', '<Plug>(leader-toggle-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

mapt('b',     'workbench.action.toggleSidebarVisibility')
mapt('B',     'workbench.action.toggleAuxiliaryBar')
mapt('e',     'workbench.action.toggleCenteredLayout')                                   --  Ctrl+E to center in MS Word
mapt('gi',    'settings.cycle.indentGuides')
mapt('gb',    'settings.cycle.bracketPairs')
mapt('n',     'settings.cycle.lineNumbers')
mapt('p',     'workbench.action.togglePanel')
mapt('P',     'workbench.action.toggleMaximizedPanel')
mapt('s',     'workbench.action.toggleStatusbarVisibility')
mapt('t',     'workbench.action.toggleLightDarkThemes')
mapt('w',     'editor.action.toggleWordWrap')
mapt('z',     'workbench.action.toggleZenMode')
mapt('_',     'workbench.action.toggleMenuBar')                                 --  Menus have underscores for selection
mapt('>',     'breadcrumbs.toggle')                                               --  breadcrumbs use '>' for separators
mapt('<Tab>', 'workbench.action.toggleTabsVisibility')


--[[ SOURCE-CONTROL ]]--------------------------------------------------------------------------------------------------
map.set('n', '<Leader>v', '<Plug>(leader-vcs-map)', {remap=true, silent=true})
local maps = function(key, cmd)
  map.set('n', '<Plug>(leader-vcs-map)' .. key, '<Cmd>call VSCodeNotify("' .. cmd .. '")<CR>', {remap=true})
end

maps('a', 'perforce.annotate')
maps('d', 'perforce.diff')
maps('e', 'perforce.edit')
maps('s', 'perforce.opened')                                                                                 -- (s)tatus


--[[ EXTENSIONS ]]------------------------------------------------------------------------------------------------------
-- Commentary
map.set({'n', 'o', 'x'}, 'gc', '<Plug>VSCodeCommentary', {remap=true})
map.set('n', 'gcc', '<Plug>VSCodeCommentaryLine', {remap=true})
