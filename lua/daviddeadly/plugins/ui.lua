return {
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    version = '*',
    opts = {}
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      { 'MunifTanjim/nui.nvim' },

      {
        'rcarriga/nvim-notify',
        opts = {
          background_colour = '#000000',
          stages = 'fade',
          render = 'compact'
        },
        keys =  {
          { "<leader>nd", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss all Notifications", },
        }
      }
    }
  }
}
