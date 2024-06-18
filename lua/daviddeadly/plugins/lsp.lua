local running_on_nix = vim.fn.executable("nix") == 1

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{
			"williamboman/mason.nvim",
			enabled = not running_on_nix,
			config = true,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			enabled = not running_on_nix,
		},

		{
			"hrsh7th/cmp-nvim-lsp",
		},

		{
			"ray-x/lsp_signature.nvim",
			opts = {},
			main = "lsp_signature",
		},

		-- {
		--   'creativenull/efmls-configs-nvim',
		--   version = 'v1.x.x', -- version is optional, but recommended
		-- },

		{
			"NvChad/nvim-colorizer.lua",
			opts = {
				user_default_options = {
					tailwind = true,
					mode = "foreground",
					always_update = true,
				},
			},
		},

		-- Useful status updates for LSP
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

		{ "onsails/lspkind.nvim" },

		{
			"SmiteshP/nvim-navbuddy",
			dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
			opts = { lsp = { auto_attach = true } },
		},

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",
	},

	config = function()
		local on_attach = function(client, bufnr)
			local signature = require("lsp_signature")
			signature.on_attach({
				bind = true, -- This is mandatory, otherwise border config won"t get registered.
				toggle_key = "<M-x>",
				toggle_key_flip_floatwin_setting = true,
				floating_window = false,
				noice = true,
				handler_opts = {
					border = "rounded",
				},
			}, bufnr)

			if client.name == "tailwindcss" or client.name == "cssls" then
				require("colorizer").attach_to_buffer(0)
			end

			local nmap = function(keys, func, desc, modes)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set(modes or "n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>rn", vim.lsp.buf.rename, "rename")
			nmap("<leader>ca", vim.lsp.buf.code_action, "code action", { "n", "v" })

			nmap("gd", vim.lsp.buf.definition, "goto definition")
			nmap("gr", function()
				require("telescope.builtin").lsp_references()
			end, "goto references")
			nmap("gI", function()
				require("telescope.builtin").lsp_implementations()
			end, "goto implementations")
			nmap("<leader>D", vim.lsp.buf.type_definition, "Type definition")
			nmap("<leader>dS", function()
				require("telescope.builtin").lsp_document_symbols()
			end, "Document symbols")
			nmap("<leader>ds", require("nvim-navbuddy").open, "Workspace symbols (Navbuddy)")
			nmap("<leader>ws", function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end, "Workspace symbols")

			-- See `:help K` for why this keymap
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<M-x>", signature.toggle_float_win, "Toggle Signature Documentation")

			nmap("<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbol (vim)")
			nmap("<leader>vd", function()
				vim.diagnostic.open_float()
			end, "Open diagnostics (vim)")
			nmap("[d", function()
				vim.diagnostic.goto_next()
			end, "Next diagnostic")
			nmap("]d", function()
				vim.diagnostic.goto_prev()
			end, "Previous diagnostic")
			-- Lesser used LSP functionality
			nmap("gD", vim.lsp.buf.declaration, "Goto declaration")
			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "workspace add folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "workspace remove folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "workspace list folders")

			-- nmap("<M-f>", "<CMD>Format<CR>", "Format file", { "n", "v" })
			--
			-- -- Create a command `:Format` local to the LSP buffer
			--
			-- vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
			--   vim.lsp.buf.format({ async = true })
			-- end, { desc = "Format current buffer with LSP (async)" })
		end

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. They will be passed to
		--  the `settings` field of the server config. You must look up that documentation yourself.
		--
		--  If you want to override the default filetypes that your language server will attach to you can
		--  define the property "filetypes" to the map in question.

		-- EFM language server configs
		-- local eslint = require('efmls-configs.linters.eslint')
		-- local prettier = require('efmls-configs.formatters.prettier')
		-- local stylua = require('efmls-configs.formatters.stylua')
		-- local luacheck = require('efmls-configs.linters.luacheck')
		--
		-- local languages = {
		--   typescript = { eslint, prettier },
		--   lua = { luacheck, stylua },
		-- }

		local servers = {
			pyright = {},
			tsserver = {},
			angularls = {},
			nil_ls = {
				testSetting = 42,
				formatting = {
					command = { "nixpkgs-fmt" },
				},
			},
			astro = {},
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},
			-- eslint = {}, -- lsp in favor of nvim_lint?? double errors

			lua_ls = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},

			-- linting and formatting
			-- efm = {
			--   filetypes = vim.tbl_keys(languages),
			--   init_options = { documentFormatting = true, documentRangeFormatting = true },
			--   settings = {
			--     rootMarkers = { ".git/" },
			--     languages = languages
			--   }
			-- }
		}

		-- Setup neovim lua configuration
		require("neodev").setup()

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- mannually installing lsp servers
		-- mason is not necessary in nixos
		if running_on_nix then
			for server_name, _ in pairs(servers) do
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				})
			end

			return
		end

		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				})
			end,
		})
	end,
}
