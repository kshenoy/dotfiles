-- I'm using packer for package management
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd "packadd packer.nvim"
end


-- Initialize packer
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'  -- let packer manage itself
    use 'nvim-lua/plenary.nvim'
    use 'wincent/base16-nvim'
    use 'tpope/vim-repeat'

    ---[[ Comment ------------------------------------------------------------------------------------------------------
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    }
    --]]

    ---[[ FZF ----------------------------------------------------------------------------------------------------------
    use {
        'ibhagwan/fzf-lua',
        config = function()
            require('fzf-lua').setup({
                winopts = {
                    preview = {
                        hidden = 'hidden',  -- The previewer is a bit slower than fzf.vim so disabling it by default
                    }
                }
            })

            local map = vim.keymap
            map.set('n', '<Plug>(leader-buffer-map)b', "<Cmd>lua require('fzf-lua').buffers({ winopts = { preview = { hidden='hidden' }}})<CR>", {desc="Switch buffer", silent=true})
            map.set('n', '<Plug>(leader-file-map)f',   "<Cmd>lua require('fzf-lua').files()<CR>", {desc="Find file", silent=true})
            map.set('n', '<Plug>(leader-file-map)F',   "<Cmd>lua require('fzf-lua').files({cwd='.'})<CR>", {desc="Find file from here", silent=true})
            map.set('n', '<Plug>(leader-file-map)r',   "<Cmd>lua require('fzf-lua').oldfiles()<CR>", {desc="Recent files", silent=true})
            map.set('n', "<Leader>'",                  "<Cmd>lua require('fzf-lua').resume()<CR>",  {desc="Resume last Fzf op", silent=true})
            map.set('n', '<Plug>(leader-help-map)b',   "<Cmd>lua require('fzf-lua').keymaps()<CR>", {desc="Describe bindings", silent=true})
            map.set('n', '<Plug>(leader-open-map)l',   "<Cmd>lua require('fzf-lua').loclist()<CR>",  {desc="Open Location List", silent=true})
            map.set('n', '<Plug>(leader-open-map)q',   "<Cmd>lua require('fzf-lua').quickfix()<CR>", {desc="Open QuickFix", silent=true})
            map.set('n', '<Plug>(leader-open-map)l',   "<Cmd>lua require('fzf-lua').loclist()<CR>",  {desc="Open Location List", silent=true})
            map.set('n', '<Plug>(leader-open-map)q',   "<Cmd>lua require('fzf-lua').quickfix()<CR>", {desc="Open QuickFix", silent=true})
            map.set('n', '<Plug>(leader-search-map)b', "<Cmd>lua require('fzf-lua').blines()<CR>", {desc="Search current buffer", silent=true})
            map.set('n', '<Plug>(leader-search-map)B', "<Cmd>lua require('fzf-lua').lines()<CR>", {desc="Search all buffers", silent=true})

        end,
    }
    --]]

    ---[[ Ouroboros ----------------------------------------------------------------------------------------------------
    use {
        'jakemason/ouroboros',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            vim.api.nvim_create_autocmd({"Filetype"}, {
                desc = "Switch between header and implementation",
                callback = function()
                    vim.keymap.set('n', "<Leader>ma", "<Cmd>Ouroboros<CR>", {desc="Switch between header and implementation", buffer=true, silent=true})
                end,
            })
        end,
    }
    --]]

    ---[[ Treesitter ---------------------------------------------------------------------------------------------------
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        config = function()
            require('nvim-treesitter.configs').setup{
                -- A list of parser names, or "all"
                ensure_installed = {"cpp", "lua"},

                -- Automatically install missing parsers when entering buffer
                auto_install = true,

                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                }
            }

            -- Better folding
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr   = "nvim_treesitter#foldexpr()"
        end,
    }
    --]]

    --[[
    use {
        'williamboman/nvim-lsp-installer',
        config = function()
            require('nvim-lsp-installer').on_server_ready(function(server)
                local opts = {}
                if server.name == "sumneko_lua" then
                    opts = {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim', 'use' }
                                },
                            }
                        }
                    }
                end
                server:setup(opts)
            end)
        end,
    }
    --]]

    --[[ Mason --------------------------------------------------------------------------------------------------------
    use {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "…",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    }

    use {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "sumneko_lua", "clangd" },
            })
        end,
    }
    --]]

    use "neovim/nvim-lspconfig"

    -- Automatically set up the configuration after cloning packer.nvim. Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
