return {
  'echasnovski/mini.files', version = '*',
  opts = {
    options = {
      permanent_delete = true,
      use_as_default_explorer = true,
    },

    windows = {
      preview = true
    }
  },
  keys = {
    { '<leader>e', '<cmd>:lua MiniFiles.open()<cr>', desc = 'Mini [E]xplorer' }
  }
}
