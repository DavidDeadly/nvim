-- luacheck: globals vim
local eslint_filetypes = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"vue",
	"html",
}

return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})

			require("lint").linters_by_ft = {
				javascript = { "eslint" },
				typescript = { "eslint" },
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				html = { "eslint" },

				lua = { "luacheck" },

				python = { "flake8" },
			}
		end,
	},

	{

		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<M-f>",
				function()
					require("conform").format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 500,
					})
				end,
				mode = { "n", "v" },
				desc = "Format file or range (in visual mode) with conform",
			},
		},
		opts = {
			-- format_on_save = {
			-- 	lsp_fallback = true,
			-- 	async = false,
			-- 	timeout_ms = 500,
			-- },
			formatters_by_ft = {
				lua = { "stylua" },

				python = { "isort", "black" },

				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
			},
		},
	},

	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"davidmh/cspell.nvim",
			},
		},
		opts = function()
			local none_ls = require("null-ls")
			local cspell = require("cspell")

			local diagnostics_conf = {
				method = none_ls.methods.DIAGNOSTICS_ON_SAVE,
			}

			return {
				sources = {
					-- typescript
					-- none_ls.builtins.code_actions.eslint_d,
					none_ls.builtins.code_actions.eslint.with({
						filetypes = eslint_filetypes,
					}),

					-- spelling
					cspell.diagnostics.with(diagnostics_conf),
					cspell.code_actions,
				},
			}
		end,
	},
}
