local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 60
local height = 20

return {
  {
    'echasnovski/mini.files', version = '*',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', opt = true },
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
      { '<leader>m', '<cmd>:lua MiniFiles.open()<cr>', desc = 'Mini [E]xplorer' }
    }
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      { 'antosha417/nvim-lsp-file-operations' }
    },
    opts = {
      sort_by = "case_sensitive",
      view = {
        float = {
          enable = true,
          open_win_config = {
            border = "rounded",
            relative = 'editor',
            width = width,
            height = height,
            row = (gheight - height) * 0.4,
            col = (gwidth - width) * 0.5,
          },
        },
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        custom = { "^.git$" }
      },
      actions = {
        open_file = {
          quit_on_open = true,
        }
      },
      filesystem_watchers = {
        enable = true
      },
      reload_on_bufenter = true
    },
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file explorer' },
      { '<leader>E', '<cmd>NvimTreeFindFile<cr>', desc = 'Find file in file explorer' },
    }
  }
}
