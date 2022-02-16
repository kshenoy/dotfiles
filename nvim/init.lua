-- Package management
-- [[https://github.com/wbthomason/packer.nvim#bootstrapping][Bootstrap packer.nvim]]

-- [[file:../../nvim.org::*Package management][Package management:1]]
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
-- Package management:1 ends here



-- Initialize packer

-- [[file:../../nvim.org::*Package management][Package management:2]]
require('packer').startup(function(use)
    use 'b0o/mapx.nvim'
    use 'machakann/vim-sandwich'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require'Comment'.setup()
        end
    }

    -- This must be at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end
)
-- Package management:2 ends here

-- [[file:../../nvim.org::*\[\[https:/github.com/b0o/mapx.nvim\]\[mapx\]\]][[[https://github.com/b0o/mapx.nvim][mapx]]:2]]
require('mapx').setup{ global = true }
-- [[https://github.com/b0o/mapx.nvim][mapx]]:2 ends here

-- vscode-only settings

-- [[file:../../nvim.org::*vscode-only settings][vscode-only settings:1]]
if vim.g.vscode then
    nnoremap('z=', "<Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<Cr>")
end
-- vscode-only settings:1 ends here

-- nvim-only settings

-- [[file:../../nvim.org::*nvim-only settings][nvim-only settings:1]]
if not vim.g.vscode then
end
-- nvim-only settings:1 ends here
