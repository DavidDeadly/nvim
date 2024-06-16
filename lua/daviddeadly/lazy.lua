lazypath = vim.fn.stdpath("data") .. "/lazy"
local lazy = lazypath .. "/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazy,
	})
end
vim.opt.rtp:prepend(lazy)

require("lazy").setup("daviddeadly.plugins", {
	install = {
		missing = true,
		colorscheme = { "catppuccin" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})

vim.keymap.set("n", "<leader>l", vim.cmd.Lazy, { desc = "open lazy" })
