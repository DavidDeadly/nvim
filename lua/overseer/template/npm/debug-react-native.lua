local function file_exists(name)
	local file = io.open(name, "r")

	if not file then
		return false
	end

	io.close(file)
	return true
end

return {
	name = "Debug React Native",
	builder = function()
		return {
			cmd = { "node" },
			args = { "src/standalone.js" },
			name = "node react-native debug",
			cwd = lazypath .. "/nvim-dap-reactnative",
			env = {
				RN_DEBBUGER_WD = vim.fn.getcwd(),
			},
		}
	end,
	desc = "Inpect on React Native",
	tags = { require("overseer").TAG.BUILD },
	priority = 50,
	condition = {
		filetype = { "typescriptreact", "javascriptreact" },
		dir = "~/Dev",
		callback = function()
			return file_exists(vim.fn.getcwd() .. "/metro.config.js")
		end,
	},
}
