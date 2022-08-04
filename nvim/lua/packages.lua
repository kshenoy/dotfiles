

-- Now lets populate the packages.lua file:

-- [[https://github.com/wbthomason/packer.nvim#bootstrapping][Bootstrap packer.nvim]]

-- [[file:../../dotfiles/nvim.org::*Package management][Package management:2]]
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end
-- Package management:2 ends here



-- Initialize packer

-- [[file:../../dotfiles/nvim.org::*Package management][Package management:3]]
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'  -- Let packer manage itself
    

    -- vscode-only plugins
    local isVsCode = function()
        return vim.g.vscode ~= nil
    end

    -- neovim-only plugins
    local isNeovim = function()
        return vim.g.vscode == nil
    end
    use {
        'wincent/base16-nvim',
        cond = isNeovim,
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require'Comment'.setup()
        end,
        cond = isNeovim,
    }
    use {
        'ibhagwan/fzf-lua',
        cond = isNeovim,
        config = function()
            require('fzf-lua').setup({
                winopts = {
                    preview = {
                        hidden = 'hidden'
                    }
                }
            })
        end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
end)
-- Package management:3 ends here
