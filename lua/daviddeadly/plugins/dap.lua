local localhost = {
	"http://localhost:3000",
	"http://localhost:8080",
	"http://localhost:5173",
	"http://localhost:4200",
}

local function pick_url()
	local coro = assert(coroutine.running())

	vim.schedule(function()
		vim.ui.select(localhost, {
			prompt = "Select URL: ",
			telescope = require("telescope.themes").get_dropdown(),
		}, function(choice)
			if choice == nil then
				vim.ui.input({
					prompt = "Custom URL: ",
				}, function(input)
					if input == nil then
						coroutine.resume(coro, localhost[1])
						return
					end

					coroutine.resume(coro, input)
				end)
				return
			end

			coroutine.resume(coro, choice)
		end)
	end)

	local url = coroutine.yield()
	return url
end

local dap_icons = {
	Stopped = { "󰁕 ", "DapStopped" },
	Breakpoint = { " ", "DapBreakpoint" },
	BreakpointCondition = { " ", "DapBreakpoint" },
	BreakpointRejected = { " ", "DapBreakpoint" },
	LogPoint = { ".>", "DapLogPoint" },
}

local function dap_colors()
	vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

	vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
	vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })

	for name, sign in pairs(dap_icons) do
		sign = type(sign) == "table" and sign or { sign }
		vim.fn.sign_define(
			"Dap" .. name,
			{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
		)
	end

	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		group = vim.api.nvim_create_augroup("DapColorscheme", { clear = true }),
		desc = "prevent colorscheme clears self-defined DAP icon colors.",
		callback = dap_colors,
	})
end

local node_filetypes = { "javascriptreact", "typescriptreact", "typescript", "javascript" }

return {
	"mfussenegger/nvim-dap",
	keys = {
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Breakpoint Condition",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>cb",
			function()
				require("dap").clear_breakpoints()
			end,
			desc = "Clear all breakpoints",
		},
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "Run to Cursor",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Continue",
		},
		{
			"<leader>d_",
			function()
				require("dap").run_last()
			end,
			desc = "Run last adapter",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = "Pause",
		},
		{
			"<leader>dE",
			function()
				require("dap").set_exception_breakpoints({ "all" })
			end,
			desc = "Exception breakpoints all",
		},
		{ "<leader>dr", ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l', desc = "Toggle REPL" },
		{ "<leader>dk", ':lua require"dap".up()<CR>zz', desc = "Upstairs the callstack" },
		{ "<leader>dj", ':lua require"dap".down()<CR>zz', desc = "Downstairs the callstack" },
		{
			"<leader>d?",
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end,
			desc = "Show scopes",
		},
	},
	dependencies = {
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},

		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = {
				"williamboman/mason.nvim",
			},
			opts = {
				handlers = {},
				ensure_installed = {
					"codelldb",
					"delve",
				},
			},
		},

		{
			"rcarriga/cmp-dap",
			opts = {
				enabled = function()
					print(vim.api.nvim_buf_get_option(0, "buftype"))
					return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
			},
			config = function(_, opts)
				require("cmp").setup(opts)

				require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
					sources = {
						{ name = "dap" },
					},
				})
			end,
		},

		{
			"nvim-telescope/telescope-dap.nvim",
			keys = {
				{
					"<leader>DB",
					function()
						require("telescope").extensions.dap.list_breakpoints()
					end,
					desc = "Dap - Breakpoints",
				},
				{
					"<leader>dv",
					function()
						require("telescope").extensions.dap.variables()
					end,
					desc = "Dap - Variables",
				},
				{
					"<leader>df",
					function()
						require("telescope").extensions.dap.frames()
					end,
					desc = "Dap - Frames",
				},
				{
					"<leader>DC",
					function()
						require("telescope").extensions.dap.commands()
					end,
					desc = "Dap - Commands",
				},
			},
			config = function()
				require("telescope").load_extension("dap")
			end,
		},

		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"nvim-neotest/nvim-nio",
			},
			opts = {
				layouts = {
					{
						elements = {
							{
								id = "stacks",
								size = 0.25,
							},
							{
								id = "breakpoints",
								size = 0.25,
							},
							{
								id = "watches",
								size = 0.25,
							},
							{
								id = "scopes",
								size = 0.25,
							},
						},
						position = "right",
						size = 40,
					},
					{
						elements = {
							{
								id = "repl",
								size = 1,
							},
						},
						position = "bottom",
						size = 10,
					},
				},
			},
			keys = {
				{
					"<leader>du",
					function()
						require("dapui").toggle({})
					end,
					desc = "Dap UI",
				},
				{
					"<leader>dR",
					function()
						require("dapui").open({ reset = true })
					end,
					desc = "Dap UI (reset)",
				},
				{
					"<leader>de",
					function()
						require("dapui").eval()
					end,
					desc = "Eval",
					mode = { "n", "v" },
				},
			},
			config = function(_, opts)
				local dap = require("dap")
				local dapui = require("dapui")

				---@diagnostic disable-next-line: missing-fields
				dapui.setup(opts)

				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open({ reset = true })
				end

				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close({})
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close({})
				end
			end,
		},

		{
			"mxsdev/nvim-dap-vscode-js",
			dependencies = {
				{
					"microsoft/vscode-js-debug",
					version = "1.76.1",
					build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
				},

				{
					"sultanahamer/nvim-dap-reactnative",
					build = "npm install && tsc",
				},
			},
			opts = {
				debugger_path = lazypath .. "/vscode-js-debug",
				debugger_cmd = { "vsDebugServer" },
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			},
			config = function(_, opts)
				local dap = require("dap")
				require("dap-vscode-js").setup(opts)

				for _, language in ipairs(node_filetypes) do
					if not dap.configurations[language] then
						dap.configurations[language] = {
							{
								type = "pwa-node",
								request = "launch",
								name = "Launch file",
								program = "${file}",
								cwd = "${workspaceFolder}",
								skipFiles = { "<node_internals>/**" },
							},
							{
								type = "pwa-node",
								request = "attach",
								name = "Attach to Nvim React Native",
								program = "${file}",
								cwd = vim.fn.getcwd(),
								sourceMaps = true,
								protocol = "inspector",
								port = 35000,
								skipFiles = { "<node_internals>/**" },
							},
							{
								type = "pwa-node",
								request = "attach",
								name = "Attach",
								processId = require("dap.utils").pick_process,
								cwd = "${workspaceFolder}",
								skipFiles = { "<node_internals>/**" },
							},
							{
								type = "pwa-chrome",
								request = "launch",
								name = "Launch chromium",
								url = pick_url,
								sourceMaps = true,
								webRoot = "${workspaceFolder}/code",
								protocol = "inspector",
								port = 9222,
								runtimeExecutable = "/usr/bin/vivaldi-stable",
								skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
							},
							{
								type = "pwa-chrome",
								request = "attach",
								name = "Attach chromium",
								sourceMaps = true,
								webRoot = "${workspaceFolder}/code",
								protocol = "inspector",
								port = 9222,
								skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
							},
							{
								name = "Deno debug restricted",
								type = "pwa-node",
								request = "launch",
								runtimeExecutable = "deno",
								runtimeArgs = {
									"run",
									"--inspect-wait",
								},
								program = "${file}",
								cwd = "${workspaceFolder}",
								attachSimplePort = 9229,
							},
							{
								name = "Deno debug",
								type = "pwa-node",
								request = "launch",
								runtimeExecutable = "deno",
								runtimeArgs = {
									"run",
									"--inspect-wait",
									"--allow-all",
								},
								program = "${file}",
								cwd = "${workspaceFolder}",
								attachSimplePort = 9229,
							},
						}
					end
				end
			end,
		},
	},
	config = function()
		require("overseer").enable_dap(true)
		local dap = require("dap")

		local cpp_port = 13123
		dap.adapters.codelldb = {
			type = "server",
			port = cpp_port,
			executable = {
				command = "codelldb",
				args = { "--port", cpp_port },
			},
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					local dir = vim.fn.getcwd() .. "/build"
					local command = "find " .. dir .. " -maxdepth 1 -type f -executable"
					local binaries = {}

					local handle = io.popen(command)
					if handle == nil then
						print("Could not run command: " .. command)
						return
					end

					for line in handle:lines() do
						table.insert(binaries, line)
					end

					if #binaries == 0 then
						print("No binaries found in " .. dir)
						return
					end

					vim.ui.select(binaries, {
						prompt = "Select executable: ",
						format_item = function(executable)
							return executable
						end,
					}, function(executable)
						if executable == nil then
							print("No executable selected")
							return
						end

						dap.run({
							name = "Launch file",
							type = "codelldb",
							request = "launch",
							program = executable,
							cwd = "${workspaceFolder}",
							stopOnEntry = false,
						})
					end)
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		dap_colors()
	end,
}
