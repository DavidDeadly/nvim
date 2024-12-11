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
	event = "VeryLazy",
	dependencies = {
		{ "echasnovski/mini.icons", config = MiniIconsSetup },
	},
	opts = {
		globalstatus = true,
		theme = "catppuccin",
		tabline = {
			lualine_a = {
				{
					function()
						local formatters = require("lint").linters_by_ft[vim.bo.filetype]
						return table.concat(formatters, ", ") or "None"
					end,
					icon = "󱏚",
					separator = { left = "", right = "" },
					color = {
						bg = "#1be471",
						fg = "#2c092a",
						gui = "italic,bold",
					},
					cond = function()
						return type(package.loaded["lint"]) == "table"
					end,
				},
				{
					function()
						local formatters = require("conform").list_formatters()
						local formatters_name = {}
						for _, x in ipairs(formatters) do
							table.insert(formatters_name, x.name)
						end

						return table.concat(formatters_name, "; ") or "None"
					end,
					icon = "",
					separator = { left = "", right = "" },
					color = {
						bg = "#e785e2",
						fg = "#2c092a",
						gui = "italic,bold",
					},
					cond = function()
						return type(package.loaded["conform"]) == "table"
					end,
				},
				{
					"buffers",
					hide_filename_extension = false,
				},
			},
			lualine_c = {
				{
					function()
						return require("noice").api.status.mode.get()
					end,
					cond = function()
						return package.loaded["noice"] and require("noice").api.status.mode.has()
					end,
					color = { fg = "#ff9e64" },
				},
			},
			lualine_y = {
				{
					"overseer",
					cond = function()
						return type(package.loaded["overseer"]) == "table"
					end,
				},
				{
					function()
						return require("dap").status()
					end,
					cond = function()
						return package.loaded["dap"] and require("dap").status() ~= ""
					end,
					icon = "",
					color = fg("Debug"),
				},
			},
			lualine_z = { "tabs" },
		},
		sections = {
			lualine_a = {
				"mode",
			},
			lualine_c = {
				{
					require("lualine.components.wakatime").today_time,
					cond = function()
						return vim.g["loaded_wakatime"] == 1
					end,
					icon = "󱑆",
					color = { fg = "#00ffff" },
				},
				"selectioncount",
			},
			lualine_x = {
				{
					function()
						return require("noice").api.status.command.get()
					end,
					cond = function()
						return package.loaded["noice"] and require("noice").api.status.command.has()
					end,
					color = { fg = "#ff9e64" },
				},
				{
					lazy_status.updates,
					cond = lazy_status.has_updates,
					color = { fg = "#7e9ce4" },
				},
				{
					function()
						local status = require("supermaven-nvim.api").is_running()
						local msg = status and "Normal" or "Warning"

						return icons[msg] .. " " .. msg
					end,
					cond = function()
						return type(package.loaded["supermaven-nvim"]) == "table"
					end,
					color = function()
						if not package.loaded["supermaven-nvim"] then
							return
						end

						local status = require("supermaven-nvim.api").is_running()
						return status and colors["Normal"] or colors["Warning"]
					end,
				},
				{
					function()
						local status = require("copilot.api").status.data
						return (icons[status.status] or icons[""]) .. (status.message or "")
					end,
					cond = function()
						local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
						return ok and #clients > 0
					end,
					color = function()
						if not package.loaded["copilot"] then
							return
						end
						local status = require("copilot.api").status.data
						return colors[status.status] or colors[""]
					end,
				},
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
