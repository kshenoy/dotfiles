require('packer').use {
  'tpope/vim-repeat',
  cond = 'vim.fn.empty(vim.g.vscode) == 1'
}
