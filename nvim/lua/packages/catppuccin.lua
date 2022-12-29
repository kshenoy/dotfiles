require('packer').use { -- Colorscheme
  'catppuccin/nvim', as = "catppuccin",
  cond = 'vim.fn.empty(vim.g.vscode) == 1',

  config = function()
    require("catppuccin").setup({
      flavour = "frappe", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "frappe",
      },
      transparent_background = true,
      dim_inactive = {
        enabled = true,
      },
    })

    vim.cmd('colorscheme catppuccin')
  end,
}
