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
}
