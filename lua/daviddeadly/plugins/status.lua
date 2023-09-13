local lazy_status = require("lazy.status")

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
  opts = {
    sections = {
      lualine_x = {
        {
          lazy_status.updates,
          cond = lazy_status.has_updates,
          color = { fg = '#7e9ce4' }
        },
        'encoding',
        'fileformat',
        'filetype'
      }
    }
  },
}
