-- luacheck: globals vim
local overseer = require("overseer")
local sn_frontend = vim.fn.expand("$HOME/Dev/Sofka/Summa/summa-network-frontend")

overseer.add_template_hook({
	dir = sn_frontend,
	name = "npm: start",
}, function(task_defn, util)
	task_defn.cwd = sn_frontend .. "/code"

	util.add_component(task_defn, {
		"on_output_parse",
		problem_matcher = {
			base = "$tsc",
			background = {
				beginsPattern = "ng serve",
				endsPattern = "Compiled successfully",
			},
		},
	})
end)
