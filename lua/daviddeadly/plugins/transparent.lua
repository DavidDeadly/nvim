return {
	'xiyaowong/nvim-transparent',
  config = function ()
    vim.keymap.set('n', '<A-t>', vim.cmd.TransparentToggle, { desc = '[t]ranparency toggle' })
  end
}
