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
				javascript = { "eslint", "cspell" },
				typescript = { "eslint", "cspell" },
				javascriptreact = { "eslint", "cspell"  },
				typescriptreact = { "eslint", "cspell"  },
				html = { "eslint", "cspell"  },

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
