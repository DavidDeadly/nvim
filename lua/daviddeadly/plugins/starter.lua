local function get_restore_session_item()
	local session_info = require("projections.session").info(vim.loop.cwd() or "")
	if type(session_info) == "table" then
		return {
			action = "RestoreProjectSession",
			name = "R: Restore session",
			section = "Sessions",
		}
	end
end

local function get_themes_items()
	local themes = { "rose-pine", "nightfly", "tokyonight", "catppuccin", "onedark" }
	local current_theme = vim.api.nvim_exec2("colorscheme", {
		output = true,
	}).output or ""

	themes = vim.tbl_filter(function(theme)
		return not string.find(current_theme, theme)
	end, themes)

	local themes_items = {}
	for i, theme in pairs(themes) do
		local item = {
			action = "colorscheme " .. theme,
			name = i .. ": " .. theme,
			section = "Themes",
		}

		table.insert(themes_items, item)
	end

	return themes_items
end

return {
	{
		"echasnovski/mini.starter",
		version = "*",
		opts = function()
			local starter = require("mini.starter")

			return {
				content_hooks = {
					starter.gen_hook.adding_bullet(""),
					starter.gen_hook.aligning("center", "center"),
				},
				evaluate_single = true,
				footer = os.date(),
				header = table.concat({
					[[Welcome back DavidDeadly to ]],
					[[]],
					[[     _____          ___                                    ___     ]],
					[[    /  /::\        /  /\          ___        ___          /__/\    ]],
					[[   /  /:/\:\      /  /::\        /__/\      /  /\        |  |::\   ]],
					[[  /  /:/  \:\    /  /:/\:\       \  \:\    /  /:/        |  |:|:\  ]],
					[[ /__/:/ \__\:|  /  /:/~/::\       \  \:\  /__/::\      __|__|:|\:\ ]],
					[[ \  \:\ /  /:/ /__/:/ /:/\:\  ___  \__\:\ \__\/\:\__  /__/::::| \:\]],
					[[  \  \:\  /:/  \  \:\/:/__\/ /__/\ |  |:|    \  \:\/\ \  \:\~~\__\/]],
					[[   \  \:\/:/    \  \::/      \  \:\|  |:|     \__\::/  \  \:\      ]],
					[[    \  \::/      \  \:\       \  \:\__|:|     /__/:/    \  \:\     ]],
					[[     \__\/        \  \:\       \__\::::/      \__\/      \  \:\    ]],
					[[                   \__\/           ~~~~                   \__\/    ]],
					[[───────────────────────────────────────────────────────────────────]],
				}, "\n"),
				query_updaters = [[abcdefghilmoqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMOQRSTUVWXYZ]],
				items = {
					{ action = "tab G", name = "G: Fugitive", section = "Git" },
					get_restore_session_item(),
					{ action = "Lazy update", name = "U: Update Plugins", section = "Plugins" },
					{ action = "Lazy profile", name = "T: Lazy time", section = "Plugins" },
					get_themes_items(),
					{ action = "enew", name = "E: New Buffer", section = "Builtin actions" },
					{ action = "qall!", name = "Q: Quit Neovim", section = "Builtin actions" },
				},
			}
		end,
	},
}
