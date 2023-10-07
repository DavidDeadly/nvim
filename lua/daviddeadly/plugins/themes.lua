-- luacheck: globals vim
return {
	{
		"rose-pine/neovim",
    lazy = true,
		name = "rose-pine",
	},

  { "bluz71/vim-nightfly-colors",
    lazy = true,
    name = "nightfly",
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = {
      transparent = vim.g.tranparend_enabled,
      style = "deep",
      toggle_style_key = "<F5>",
      lualine = {
        transparent = vim.g.tranparend_enabled,
      },
    },
    config = function (_, opts)
      require("onedark").setup(opts)
    end
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night"
    }
  },

	{
		"catppuccin/nvim",
		name = "catppuccin",
    priority = 1000,
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
        which_key = true,
        treesitter = true,
        treesitter_context = true,
        mason = true,
        flash = true,
        noice = true,
        telescope = true,
			},
		},
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd[[colorscheme catppuccin]]
    end,
  }
}
