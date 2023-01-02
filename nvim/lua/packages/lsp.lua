-- LSP Configuration & Plugins
require('packer').use {
  'neovim/nvim-lspconfig',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',

  requires = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'j-hui/fidget.nvim',  -- Useful status updates for LSP
  },

  config = function()
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<Plug>(leader-code-map)r', vim.lsp.buf.rename, '[C]ode [R]ename')
      nmap('<Plug>(leader-code-map)a', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('<Plug>(leader-goto-map)d', vim.lsp.buf.definition, '[G]oto [D]efinition')

      nmap('<Plug>(leader-goto-map)r', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('<Plug>(leader-goto-map)i', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
          vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
          vim.lsp.buf.formatting()
        end
      end, { desc = 'Format current buffer with LSP' })
    end

    -- Setup mason so it can manage external tooling
    require('mason').setup()

    -- Enable the following language servers
    -- Feel free to add/remove any LSPs that you want here. They will automatically be installed
    local servers = { 'clangd', 'rust_analyzer', 'pyright', 'sumneko_lua' }

    -- Ensure the servers above are installed
    require('mason-lspconfig').setup {
      ensure_installed = servers,
    }

    -- nvim-cmp supports additional completion capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    for _, lsp in ipairs(servers) do
      require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end

    -- Turn on lsp status information
    require('fidget').setup()

    -- Example custom configuration for lua
    --
    -- Make runtime files discoverable to the server
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    require('lspconfig').sumneko_lua.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = { library = vim.api.nvim_get_runtime_file('', true) },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    }
  end,
}

require('packer').use {
  'williamboman/mason.nvim',
  opt = true,
}

require('packer').use {
  'williamboman/mason-lspconfig.nvim',
  opt = true,
}

require('packer').use {
  'j-hui/fidget.nvim',
  opt = true,
}
