return {
	'xiyaowong/nvim-transparent',
  opts = {
    extra_groups = {
      "NormalFloat"
    }
  },
  config = function ()
    vim.keymap.set('n', '<A-t>', vim.cmd.TransparentToggle, { desc = '[t]ranparency toggle' })
  end
}
