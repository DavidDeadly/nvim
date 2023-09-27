-- luacheck: globals vim
local lazy_status = require("lazy.status")

local function fg(name)
	local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
	local foreground = hl and hl.fg
	return foreground and { fg = string.format("#%06x", foreground) }
end

local colors = {
	[""] = fg("Special"),
	["Normal"] = fg("Special"),
	["Warning"] = fg("DiagnosticError"),
	["InProgress"] = fg("DiagnosticWarn"),
}

local icons = {
	[""] = "",
	["Normal"] = "",
	["Warning"] = "",
	["InProgress"] = "",
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		globalstatus = true,
		tabline = {
      lualine_a = {
				{
					"buffers",
					hide_filename_extension = true,
				},
      },
			lualine_c = {
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = { fg = "#ff9e64" },
        },
				{
					function()
						return require("nvim-navic").get_location()
					end,
					cond = function()
						return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
					end,
				},
			},
      lualine_y = {
        {
          function() return "overseer" end,
          cond = function()
						return package.loaded["overseer"]
					end
        },
				{
					function()
						return "  " .. require("dap").status()
					end,
					cond = function()
						return package.loaded["dap"] and require("dap").status() ~= ""
					end,
					color = fg("Debug"),
				}
      },
			lualine_z = { "tabs" },
		},
		sections = {
			lualine_a = {
				"mode",
			},
			lualine_c = {
				"selectioncount",
			},
			lualine_x = {
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = { fg = "#ff9e64" },
        },
				{
					lazy_status.updates,
					cond = lazy_status.has_updates,
					color = { fg = "#7e9ce4" },
				},
				{
					function()
						local status = require("copilot.api").status.data
						return (icons[status.status] or icons[""]) .. (status.message or "")
					end,
					cond = function()
						local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
						return ok and #clients > 0
					end,
					color = function()
						if not package.loaded["copilot"] then
							return
						end
						local status = require("copilot.api").status.data
						return colors[status.status] or colors[""]
					end,
				}
			},
			lualine_z = {
				"location",
				function()
					return " " .. os.date("%R")
				end,
			},
		},
	},
}
