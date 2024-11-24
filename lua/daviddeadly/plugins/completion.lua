return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",

		-- Adds LSP completion capabilities
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",

		{
			"windwp/nvim-autopairs",
			opts = {},
		},
		-- Adds a number of user-friendly snippets
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local types = require("cmp.types")
		local str = require("cmp.utils.str")

		local luasnip = require("luasnip")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		local lspkind = require("lspkind")

		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.config.setup({
			region_check_events = "CursorMoved",
			delete_check_events = "TextChanged",
		})

		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping(
					cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					{ "i", "s" }
				),
				["<C-p>"] = cmp.mapping(
					cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					{ "i", "s", "c" }
				),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.abort(),
				["<M-CR>"] = cmp.mapping.complete({}),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = false,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						local entry = cmp.get_selected_entry()

						if not entry then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						end

						cmp.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						})
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s", "c" }),
			}),
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					priority = 2,
					entry_filter = function(entry, _)
						return entry:get_kind() ~= 15
					end,
				},
				{ name = "luasnip", priority = 1 },
				{ name = "path", priority = 1 },
				{ name = "buffer", priority = 1, keyword_length = 3, max_item_count = 3 },
			}),
			sorting = {
				priority_weight = 1.0,
				comparators = {
					cmp.config.compare.exact,
					cmp.config.compare.locality,
					cmp.config.compare.recently_used,
					cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
					cmp.config.compare.offset,
					cmp.config.compare.order,
					cmp.config.compare.kind,
				},
			},
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				fields = {
					cmp.ItemField.Abbr,
					cmp.ItemField.Kind,
					cmp.ItemField.Menu,
				},
				format = lspkind.cmp_format({
					mode = "symbol", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
					maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					preset = "codicons",
					menu = { -- showing type in menu
						nvim_lsp = "[LSP]",
						path = "[Path]",
						buffer = "[Buffer]",
						luasnip = "[LuaSnip]",
					},
					-- The function below will be called before any actual modifications from lspkind
					-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
					before = function(entry, vim_item)
						local word = entry:get_insert_text() -- The word being completed.

						word = entry.completion_item.InsertTextFormat == types.lsp.InsertTextFormat
								and vim.lsp.util.parse_snippet(word)
							or str.oneline(word)

						if
							entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
							and string.sub(vim_item.abbr, -1, -1) == "~"
						then
							word = word .. "~"
						end

						vim_item.abbr = word
						return vim_item
					end,
				}),
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline", keyword_length = 2 },
			}),
		})
	end,
}
