return {
	"folke/which-key.nvim",
	keys = {
		"<leader>",
		[["]],
	},
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {},
}
