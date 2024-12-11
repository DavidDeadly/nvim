local SIGNATURE_KEY_MAP = "<C-k>"

return {
	{
		"ray-x/lsp_signature.nvim",
		main = "lsp_signature",
		event = "InsertEnter",
		keys = {
			{
				SIGNATURE_KEY_MAP,
				function()
					require("lsp_signature").toggle_float_win()
				end,
				desc = "Toggle Signature Documentation",
			},
		},
		opts = {
			bind = true,
			toggle_key = SIGNATURE_KEY_MAP,
			toggle_key_flip_floatwin_setting = true,
			floating_window = false,
			noice = true,
			handler_opts = {
				border = "rounded",
			},
		},
		config = function(_, opts)
			local signature = require("lsp_signature")
			signature.setup(opts)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					signature.on_attach(opts, args.buf)
				end,
			})
		end,
	},

	{
		"SmiteshP/nvim-navbuddy",
		dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
		opts = { lsp = { auto_attach = true } },
		keys = {
			{
				"<leader>ds",
				function()
					require("nvim-navbuddy").open()
				end,
				"Workspace symbols (Navbuddy)",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },

			{ "williamboman/mason-lspconfig.nvim" },

			{ "hrsh7th/cmp-nvim-lsp", enabled = false },

			{ "saghen/blink.cmp" },

			{ "onsails/lspkind.nvim" },

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
				-- 	settings = {
				-- 		testSetting = 42,
				-- 		formatting = {
				-- 			command = { "nixpkgs-fmt" },
				-- 		},
				-- 	},
				-- },

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								disable = { "missing-fields" },
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local LSP_ATTACHMENT = "lsp-attachment"
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup(LSP_ATTACHMENT, { clear = true }),
				callback = function(event)
					local nmap = function(keys, func, desc, modes)
						vim.keymap.set(modes or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					nmap("gd", vim.lsp.buf.definition, "goto definition")
					nmap("<leader>rn", vim.lsp.buf.rename, "rename")
					nmap("<leader>ca", vim.lsp.buf.code_action, "code action", { "n", "v" })
					nmap("K", vim.lsp.buf.hover, "Hover Documentation")
					nmap("<leader>D", vim.lsp.buf.type_definition, "Type definition")
					nmap("<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbol (vim)")
					nmap("<leader>vd", vim.diagnostic.open_float, "Open diagnostics (vim)")

					-- Lesser used LSP functionality
					nmap("gD", vim.lsp.buf.declaration, "Goto declaration")
					nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "workspace add folder")
					nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "workspace remove folder")
					nmap("<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "workspace list folders")

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup(LSP_ATTACHMENT, { clear = true }),
						callback = function()
							vim.lsp.buf.clear_references()
						end,
					})

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if not client then
						return
					end

					if not client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						return
					end

					local toggle_inlay_hints = function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end

					nmap("<leader>th", toggle_inlay_hints, "[T]oggle Inlay [H]ints")
					toggle_inlay_hints()
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(opts.servers),

				handlers = {
					function(server_name)
						local server = opts.servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
