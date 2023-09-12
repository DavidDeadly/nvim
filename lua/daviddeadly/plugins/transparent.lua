return {
	'xiyaowong/nvim-transparent',
  cmd = "TransparentToggle",
  init = function ()
    vim.cmd("TransparentToggle")
  end,
  opts = {
    extra_groups = {
      "NormalFloat"
    }
  },
  config = function ()
    vim.keymap.set('n', '<A-t>', vim.cmd.TransparentToggle, { desc = '[t]ranparency toggle' })
  end
}
