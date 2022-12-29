require('packer').use {
  'nvim-lualine/lualine.nvim',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',

  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
    }
  end,
}
