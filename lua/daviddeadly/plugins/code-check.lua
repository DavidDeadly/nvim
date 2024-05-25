-- luacheck: globals vim
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
				javascript = { "eslint_d", "cspell" },
				typescript = { "eslint_d", "cspell" },
				javascriptreact = { "eslint_d", "cspell"  },
				typescriptreact = { "eslint_d", "cspell"  },
				html = { "eslint_d", "cspell"  },

				lua = { "luacheck", "cspell" },

				python = { "flake8", "cspell" },

        go = { "golangcilint", "cspell" },

				sh = { "shellcheck", "cspell" },
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

        go = {  "goimports", "gofumpt" },

        rust = { "rustfmt" },

				sh = { "beautysh" },

				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
			},
		},
	},
}
