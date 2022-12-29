require('packer').use {
  'kyazdani42/nvim-web-devicons',
  cond = 'vim.fn.empty(vim.g.vscode) == 1',
}
