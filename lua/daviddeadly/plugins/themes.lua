-- luacheck: globals vim
return {
	{
		"rose-pine/neovim",
    event = "VeryLazy",
		name = "rose-pine",
	},

  { "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,
    priority = 1000,
  },

  {
    "navarasu/onedark.nvim",
    event = "VeryLazy",
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
    lazy = false,
    opts = {
      style = "night"
    }
  },

	{
		"catppuccin/nvim",
		name = "catppuccin",
    priority = 1000,
    event = "VeryLazy",
		opts = {
			flavour = "mocha",
      term_colors = true,
			dim_inactive = {
				enabled = true,
			},
      color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#000000",
				},
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
			},
		},
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd[[colorscheme catppuccin]]
    end,
  }
}
