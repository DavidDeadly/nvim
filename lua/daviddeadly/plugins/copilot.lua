return {
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		event = "InsertEnter",
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = {
				auto_trigger = true,
			},
			panel = { enabled = false },
		},
	},

	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		opts = {
			{
				keymaps = {
					accept_suggestion = "Tab",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
			},
		},
	},
}
