require('packer').use { -- complementary pairs of mappings
  'tpope/vim-unimpaired',
  cond = 'vim.fn.empty(vim.g.vscode) == 1'
}
