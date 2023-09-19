return {
	{
		"rose-pine/neovim",
    event = 'VeryLazy',
		name = "rose-pine",
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "mocha",
      term_colors = true,
			dim_inactive = {
				enabled = true,
			},
			integrations = {
        cmp = true,
        mini = true,
        gitsigns = true,
        nvimtree = true,
        which_key = true,
        treesitter = true,
        treesitter_context = true,
        navic = {
          enabled = true,
          custom_bg = "lualine"
        },
        mason = true,
        flash = true,
        noice = true,
        telescope = true,
        notify = true,
			},
		},
		lazy = false,
		priority = 1000,
		config = function(_, opts)
      require("catppuccin").setup(opts)

			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
}
