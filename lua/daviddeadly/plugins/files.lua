local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 60
local height = 20

return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_files = true,
			keymaps = {
				["h"] = "actions.parent",
				["l"] = "actions.select",
			},
			view_options = {
				show_hidden = false,
				natural_order = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},
			win_options = {
				wrap = true,
			},
			float = {
				padding = 5,
				max_width = 80,
				border = "rounded",
				win_options = {
					winblend = 0,
				},
			},
		},
		keys = {
			{
				"-",
				function()
					require("oil").open()
				end,
				desc = "open [-]il file explorer",
			},
			{
				"_",
				function()
					require("oil").open_float()
				end,
				desc = "open [_]il float file explorer",
			},
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = function()
			local nvim_tree = vim.api.nvim_create_augroup("NvimTreeResized", { clear = true })

			vim.api.nvim_create_autocmd("VimResized", {
				group = nvim_tree,
				callback = vim.schedule_wrap(function()
					gwidth = vim.api.nvim_list_uis()[1].width
					gheight = vim.api.nvim_list_uis()[1].height

					require("nvim-tree.view").View.float.open_win_config.row = (gheight - height) * 0.4
					require("nvim-tree.view").View.float.open_win_config.col = (gwidth - width) * 0.5

					if require("nvim-tree.utils").is_nvim_tree_buf() then
						vim.cmd.NvimTreeToggle()
						vim.cmd.NvimTreeToggle()
					end
				end),
			})

			return {
				sort_by = "case_sensitive",
				view = {
					float = {
						enable = true,
						open_win_config = {
							border = "rounded",
							relative = "editor",
							width = width,
							height = height,
							row = (gheight - height) * 0.4,
							col = (gwidth - width) * 0.5,
						},
					},
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					custom = { "^.git$" },
				},
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
				filesystem_watchers = {
					enable = true,
				},
				reload_on_bufenter = true,
			}
		end,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
			"antosha417/nvim-lsp-file-operations",
		},
		cmd = {
			"NvimTreeToggle",
			"NvimTreeFindFile",
			"NvimTreeCollapse",
		},
		keys = {
			{ "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "[f]ile [t]ree" },
			{ "<leader>fT", "<cmd>NvimTreeFindFileToggle<cr>", desc = "find [f]ile [t]ree" },
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)
			require("lsp-file-operations").setup()
		end,
	},
}
