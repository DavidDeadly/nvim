return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gf', vim.cmd.Git, desc = 'Git fugitive' }
    }
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { '<leader>gg', vim.cmd.LazyGitCurrentFile, desc = '[G]it root directory' },
      { '<leader>gG', vim.cmd.LazyGit, desc = '[G]it current directory' },
    }
  },
}
