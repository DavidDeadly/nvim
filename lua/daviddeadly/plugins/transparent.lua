return {
	'xiyaowong/nvim-transparent',
  cmd = 'TransparentEnable',
  init = function ()
    vim.cmd("TransparentEnable")
  end,
  opts = {
    groups = {
      'Normal',
      'NormalFloat',
    },
  },
  keys = {
    { '<M-t>', vim.cmd.TransparentToggle, desc = '[t]ranparency toggle'},
  },
}
