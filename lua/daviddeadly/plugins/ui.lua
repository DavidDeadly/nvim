return {
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    version = '*',
    opts = {}
  },

  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      { 'MunifTanjim/nui.nvim' },

      {
        'rcarriga/nvim-notify',
        opts = function()
          require("telescope").load_extension("notify")

          return {
            background_colour = '#000000',
            stages = 'fade',
            render = 'compact'
          }
        end,
        keys =  {
          { "<leader>nd", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss all Notifications", },
        }
      }
    }
  }
}
