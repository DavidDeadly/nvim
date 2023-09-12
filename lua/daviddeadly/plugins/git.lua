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
  },
}
