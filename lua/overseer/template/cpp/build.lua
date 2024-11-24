return {
	name = "Build current file",
	condition = {
		filetype = { "cpp" },
		dir = "~/Dev",
	},
	tags = { require("overseer").TAG.BUILD },
	builder = function()
		local file = vim.fn.expand("%:p")

		return {
			cmd = { "c++" },
			args = { file, "-S", "-Wall", "-Werror" },
			components = {
				{
					"on_output_quickfix",
					open = true,
				},
				"default",
			},
		}
	end,
}
