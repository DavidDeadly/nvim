LAZY_PATH = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
local lazy = vim.fs.joinpath(LAZY_PATH, "/lazy.nvim")

if not vim.loop.fs_stat(LAZY_PATH) then
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

require("lazy").setup("plugins", {
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
