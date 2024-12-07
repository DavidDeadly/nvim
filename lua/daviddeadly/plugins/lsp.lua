return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", config = true },

		{ "williamboman/mason-lspconfig.nvim" },

		{ "hrsh7th/cmp-nvim-lsp", enabled = false },

		{ "saghen/blink.cmp" },

		{
			"ray-x/lsp_signature.nvim",
			main = "lsp_signature",
			config = true,
		},

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

		{ "onsails/lspkind.nvim" },

		{
			"SmiteshP/nvim-navbuddy",
			dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
			opts = { lsp = { auto_attach = true } },
		},

		-- Additional lua configuration, makes nvim stuff amazing!
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	opts = {
		servers = {
			ts_ls = {},
			angularls = {},
			astro = {},
			html = {},
			cssls = {},
			tailwindcss = {},

			pyright = {},
			clangd = {},
			gopls = {},

			-- NOTE: nix-lsp doesn't working on fedora
			-- nil_ls = {
			-- 	testSetting = 42,
			-- 	formatting = {
			-- 		command = { "nixpkgs-fmt" },
			-- 	},
			-- },

			lua_ls = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		},
	},
	config = function(_, opts)
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

			-- Lesser used LSP functionality
			nmap("gD", vim.lsp.buf.declaration, "Goto declaration")
			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "workspace add folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "workspace remove folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "workspace list folders")
		end

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		-- local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local get_lsp_server_setup = function(server_name)
			return {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = opts.servers[server_name],
				filetypes = (opts.servers[server_name] or {}).filetypes,
			}
		end

		-- mannually installing lsp servers
		-- mason is not necessary in nixos
		if Running_on_nix then
			for server_name, _ in pairs(opts.servers) do
				require("lspconfig")[server_name].setup(get_lsp_server_setup(server_name))
			end

			return
		end

		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(opts.servers),
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup(get_lsp_server_setup(server_name))
			end,
		})
	end,
}
