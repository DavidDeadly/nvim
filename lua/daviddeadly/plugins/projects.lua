-- luacheck: globals vim

return {
	{
		"gnikdroy/projections.nvim",
		event = "VeryLazy",
		branch = "pre_release",
		init = function()
			-- Autostore session on VimExit
			vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
				callback = function()
					require("projections.session").store(vim.loop.cwd() or "")
				end,
			})

			-- Switch to project if vim was started in a project dir
			vim.api.nvim_create_autocmd({ "VimEnter" }, {
				callback = function()
					if vim.fn.argc() == 0 then
						require("projections.switcher").switch(vim.loop.cwd() or "")
					end
				end,
			})

			vim.api.nvim_create_user_command("StoreProjectSession", function()
				require("projections.session").store(vim.loop.cwd() or "")
			end, {})

			vim.api.nvim_create_user_command("RestoreProjectSession", function()
				require("projections.session").restore(vim.loop.cwd() or "")
			end, {})
		end,
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
	},
}
