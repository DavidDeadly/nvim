-- luacheck: globals vim

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
      opts = {}
    },
		-- Adds a number of user-friendly snippets
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local types = require("cmp.types")
		local str = require("cmp.utils.str")

		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.config.setup({})

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
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() then
            local entry = cmp.get_selected_entry()

            if not entry then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end

            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          else
            fallback()
          end
          end, { "i", "s", "c" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", group_index = 1 },
        { name = "luasnip", group_index = 2 },
        { name = "buffer", keyword_length = 5, max_item_count = 5, group_index = 3 },
        { name = "path" },
      }),
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.exact,
					cmp.config.compare.offset,
					cmp.config.compare.scopes,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			formatting = {
				fields = {
					cmp.ItemField.Kind,
					cmp.ItemField.Abbr,
					cmp.ItemField.Menu,
				},
				format = lspkind.cmp_format({
					mode = "symbol", -- show only symbol annotations
					maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					symbol_map = { Copilot = "" },
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
