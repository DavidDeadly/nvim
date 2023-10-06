return {
  "stevearc/overseer.nvim",
	opts = function ()
    require("overseer.custom-builtins.summa")

    return {
      dap = false,
      templates = {
        "builtin",
        "ndm"
      },
    }
	end,
	keys = {
		{ "<leader>R", "<CMD>OverseerRun<CR>", desc = "Run task" },
		{ "<leader>rT", "<CMD>OverseerToggle<CR>", desc = "Toggle tasks" },
	},
}
