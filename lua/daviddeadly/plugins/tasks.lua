return {
  'stevearc/overseer.nvim',
  opts = {
    dap = false,
    templates = {
      "builtin",
      "npm"
    }
  },
  keys = {
    { '<leader>R', '<CMD>OverseerRun<CR>', desc = 'Run task' },
    { '<leader>rT', '<CMD>OverseerToggle<CR>', desc = 'Run task' },
  }
}
