return {
  {
    'echasnovski/mini.files', version = '*',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'antosha417/nvim-lsp-file-operations' }
    },
    opts = {
      options = {
        permanent_delete = false,
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
}
