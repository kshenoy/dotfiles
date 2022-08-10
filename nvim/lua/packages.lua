-- [[https://github.com/wbthomason/packer.nvim][packer.nvim]]
-- I'm using packer for package management. [[https://github.com/wbthomason/packer.nvim#bootstrapping][Bootstrap packer.nvim]]

-- [[file:../../dotfiles/nvim.org::*\[\[https:/github.com/wbthomason/packer.nvim\]\[packer.nvim\]\]][[[https://github.com/wbthomason/packer.nvim][packer.nvim]]:1]]
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end
-- [[https://github.com/wbthomason/packer.nvim][packer.nvim]]:1 ends here



-- Initialize packer

-- [[file:../../dotfiles/nvim.org::*\[\[https:/github.com/wbthomason/packer.nvim\]\[packer.nvim\]\]][[[https://github.com/wbthomason/packer.nvim][packer.nvim]]:2]]
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use {
        'wincent/base16-nvim',
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    }
    use {
        'ibhagwan/fzf-lua',
        config = function()
    _G.sel_to_ll = function(selected, opts)
        local loc_list = {}
        for i = 1, #selected do
          local file = require('fzf-lua').path.entry_to_file(selected[i], opts)
          local text = selected[i]:match(":%d+:%d?%d?%d?%d?:?(.*)$")
          table.insert(loc_list, {
            filename = file.path,
            lnum = file.line,
            col = file.col,
            text = text,
          })
        end
        vim.fn.setloclist(0, loc_list)
        -- open the location list
        vim.cmd [[
            lopen
            syntax match qfFileName /^[^|]*|[^|]*| / transparent conceal
        ]]
    end
    
    -- Add as an action to buffer providers
    require('fzf-lua').setup {
        actions = {
            buffers = { ["alt-l"] = _G.sel_to_ll }
        }
    }
    require('fzf-lua').setup({
        winopts = {
            preview = {
                -- hidden = 'hidden',  -- The previewer is a bit slower than fzf.vim so disabling it by default
            }
        }
    })
    local map = vim.keymap
    map.set('n', '<Plug>(leader-buffer-map)b', "<Cmd>lua require('fzf-lua').buffers({ winopts = { preview = { hidden='hidden' }}})<CR>", {desc="Switch buffer", silent=true})
    map.set('n', '<Plug>(leader-file-map)f', "<Cmd>lua require('fzf-lua').files()<CR>", {desc="Find file", silent=true})
    map.set('n', '<Plug>(leader-file-map)F', "<Cmd>lua require('fzf-lua').files({cwd='.'})<CR>", {desc="Find file from here", silent=true})
    map.set('n', '<Plug>(leader-file-map)r', "<Cmd>lua require('fzf-lua').oldfiles()<CR>", {desc="Recent files", silent=true})
    map.set('n', "<Leader>'",                "<Cmd>lua require('fzf-lua').resume()<CR>",  {desc="Resume last Fzf op", silent=true})
    map.set('n', '<Plug>(leader-help-map)b', "<Cmd>lua require('fzf-lua').keymaps()<CR>", {desc="Describe bindings", silent=true})
    map.set('n', '<Plug>(leader-open-map)l', "<Cmd>lua require('fzf-lua').loclist()<CR>",  {desc="Open Location List", silent=true})
    map.set('n', '<Plug>(leader-open-map)q', "<Cmd>lua require('fzf-lua').quickfix()<CR>", {desc="Open QuickFix", silent=true})
    map.set('n', '<Plug>(leader-open-map)l', "<Cmd>lua require('fzf-lua').loclist()<CR>",  {desc="Open Location List", silent=true})
    map.set('n', '<Plug>(leader-open-map)q', "<Cmd>lua require('fzf-lua').quickfix()<CR>", {desc="Open QuickFix", silent=true})
    map.set('n', '<Plug>(leader-search-map)b', "<Cmd>lua require('fzf-lua').blines()<CR>", {desc="Search current buffer", silent=true})
    map.set('n', '<Plug>(leader-search-map)B', "<Cmd>lua require('fzf-lua').lines()<CR>", {desc="Search all buffers", silent=true})
    vim.keymap.set('n', '<Plug>(leader-vcs-map)f', function()
        if require('fzf-lua.path').is_git_repo({}, true) then
            return require('fzf-lua').git_files()
        elseif require('fzf-lua.perforce').is_p4_repo({}, true) then
            return require('fzf-lua.perforce').files()
        end
    end, {desc = "Find file"})
    
    vim.keymap.set('n', '<Plug>(leader-vcs-map)F', function()
        if require('fzf-lua.path').is_git_repo({cwd='.'}, true) then
            return require('fzf-lua').git_files({cwd='.'})
        elseif require('fzf-lua.perforce').is_p4_repo({cwd='.'}, true) then
            return require('fzf-lua.perforce').files({cwd='.'})
        end
    end, {desc = "Find file from here"})
    vim.keymap.set('n', '<Plug>(leader-vcs-map)s', function()
        if require('fzf-lua.path').is_git_repo({}, true) then
            return require('fzf-lua').git_status()
        elseif require('fzf-lua.perforce').is_p4_repo({}, true) then
            return require('fzf-lua.perforce').status()
        end
    end, {desc = "Repo status"})
    vim.keymap.set('n', '<Plug>(leader-project-map)f', function()
        if require('fzf-lua.path').is_git_repo({}, true) then
            return require('fzf-lua').git_files()
        elseif require('fzf-lua.perforce').is_p4_repo({}, true) then
            return require('fzf-lua.perforce').files()
        else
            return require('fzf-lua').files()
        end
    end, {desc = "Find file"})
    
    vim.keymap.set('n', '<Plug>(leader-project-map)F', function()
        if require('fzf-lua.path').is_git_repo({cwd='.'}, true) then
            return require('fzf-lua').git_files({cwd='.'})
        elseif require('fzf-lua.perforce').is_p4_repo({cwd='.'}, true) then
            return require('fzf-lua.perforce').files({cwd='.'})
        else
            return require('fzf-lua').files({cwd='.'})
        end
    end, {desc = "Find file from here"})
        end,
    }
    use {
        'jakemason/ouroboros',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            vim.api.nvim_create_autocmd({"Filetype"}, {
                desc = "Switch between header and implementation",
                callback = function()
                    vim.keymap.set('n', "<Leader>ma", "<Cmd>Ouroboros<CR>", {desc="Switch between header and implementation", buffer=true, silent=true})
                end,
            })
        end,
    }

    -- Automatically set up the configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
-- [[https://github.com/wbthomason/packer.nvim][packer.nvim]]:2 ends here
