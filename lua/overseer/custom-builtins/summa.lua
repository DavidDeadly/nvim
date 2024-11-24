-- luacheck: globals vim
local overseer = require("overseer")
local sn_frontend = vim.fn.expand("$HOME/Dev/Sofka/Summa/summa-network-frontend")
local sn_admin = vim.fn.expand("$HOME/Dev/Sofka/Summa/summa-network-admin")
local sn_invoices = vim.fn.expand("$HOME/Dev/Sofka/Summa/summa-network-invoices")
local sn_reports = vim.fn.expand("$HOME/Dev/Sofka/Summa/summa-network-reports")

overseer.add_template_hook({
	dir = { sn_frontend, sn_admin, sn_invoices, sn_reports },
}, function(task_defn, util)
	local cwd = vim.fn.getcwd()
	task_defn.cwd = cwd == sn_invoices and cwd .. "/code/node" or cwd .. "/code"

	if task_defn.name == "npm: start" and cwd == sn_frontend then
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
	end
end)
