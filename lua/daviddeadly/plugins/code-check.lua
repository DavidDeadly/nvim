-- selene: allow(mixed_table)
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
				javascriptreact = { "eslint_d", "cspell" },
				typescriptreact = { "eslint_d", "cspell" },
				html = { "eslint_d", "cspell" },

				lua = { "selene", "cspell" },

				nix = { "statix", "cspell" },

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
			format_after_save = {
				lsp_fallback = true,
				timeout_ms = 500,
			},
			formatters_by_ft = {
				lua = { "stylua" },

				python = { "isort", "black" },

				go = { "goimports", "gofumpt" },

				rust = { "rustfmt" },

				sh = { "beautysh" },

				nix = { "nixpkgs_fmt" },

				javascript = { { "eslint_d", "prettierd", "prettier" } },
				typescript = { { "eslint_d", "prettierd", "prettier" } },
				javascriptreact = { { "eslint_d", "prettier", "prettierd" } },
				typescriptreact = { { "eslint_d", "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
			},
		},
	},
}
