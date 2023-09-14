return {
	'xiyaowong/nvim-transparent',
  cmd = 'TransparentToggle',
  init = function ()
    vim.cmd("TransparentToggle")
  end,
  opts = {
    groups = {
      'Normal',
      'NormalFloat',
    },
  },
  keys = {
    { '<A-t>', vim.cmd.TransparentToggle, desc = '[t]ranparency toggle'},
  },
}
