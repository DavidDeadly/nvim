-- luacheck: globals vim

return {
	{
		"sanathks/workspace.nvim",
		opts = {
			workspaces = {
				{ name = "Summa", path = "~/Dev/Sofka/Summa", keymap = { "<leader>S" } },
				{ name = "Isa", path = "~/Dev/Isa", keymap = { "<leader>I" } },
			},
		},
		keys = {
			{
				"<leader>ps",
				function()
					require("workspace").tmux_sessions()
				end,
				desc = "List tmux sessions",
			},
		},
	},

	{
		"gnikdroy/projections.nvim",
		event = "VeryLazy",
    branch = "pre_release",
		opts = {
			workspaces = {
				"~/Dev/Sofka/Summa",
				"~/Dev/Isa",
			},
			patterns = { ".git", ".svn", ".hg" },
		},
		keys = {
			{
				"<leader>fp",
				function()
					require("telescope").extensions.projections.projections()
				end,
				desc = "Find project",
			},
		},
		config = function(_, opts)
			require("projections").setup(opts)

			-- Autostore session on VimExit
			local Session = require("projections.session")
			vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
				callback = function()
					Session.store(vim.loop.cwd())
				end,
			})

			-- Switch to project if vim was started in a project dir
			local switcher = require("projections.switcher")
			vim.api.nvim_create_autocmd({ "VimEnter" }, {
				callback = function()
					if vim.fn.argc() == 0 then
						switcher.switch(vim.loop.cwd())
					end
				end,
			})
		end,
	},
}
