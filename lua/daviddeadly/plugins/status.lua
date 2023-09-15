local lazy_status = require("lazy.status")

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
  opts = {
    sections = {
      lualine_a = {
        'mode',
        {
          'buffers',
          hide_filename_extension = true
        }
      },
      lualine_c = { 'selectioncount' },
      lualine_x = {
        {
          lazy_status.updates,
          cond = lazy_status.has_updates,
          color = { fg = '#7e9ce4' }
        },
        {
          function() return require("copilot_status").status_string() end,
          cond = function() return require("copilot_status").enabled() end,
        },
        'encoding',
        'fileformat',
        'filetype'
      }
    }
  }
}
