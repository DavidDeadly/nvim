return {
  {
    'echasnovski/mini.starter', version = '*',
    opts = {}
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
}
