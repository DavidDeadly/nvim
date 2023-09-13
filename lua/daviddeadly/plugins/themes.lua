return {
  {
    'rose-pine/neovim',
    lazy = true,
    name = 'rose-pine'
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      dim_inactive = {
        enabled = true
      },
      integrations = {
        mini = true
      }
    },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme catppuccin-mocha')
    end,
  }
}
