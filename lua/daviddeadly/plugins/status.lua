local lazy_status = require("lazy.status")

local function show_macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
        return ""
    else
        return "Recording @" .. recording_register
    end
end

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
  [""] = '',
  ["Normal"] = '',
  ["Warning"] = '',
  ["InProgress"] = '',
}

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = function()
        require('lualine').refresh({
          place = { "tabline" },
        })
      end,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        local timer = vim.loop.new_timer()
        timer:start(
          50,
          0,
          vim.schedule_wrap(function()
            require('lualine').refresh({
              place = { "statusline" },
            })
          end)
        )
      end,
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
  opts = {
    globalstatus = true,
    tabline = {
      lualine_b = {
         {
          'buffers',
          hide_filename_extension = true
        }
      },
      lualine_c = {
        {
          "macro-recording",
          fmt = show_macro_recording,
        },
      },
      lualine_z = { 'tabs' }
    },
    sections = {
      lualine_a = {
        'mode'
      },
      lualine_c = {
        {
          function() return require("nvim-navic").get_location() end,
          cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
        },
        'selectioncount'
      },
      lualine_x = {
        {
          lazy_status.updates,
          cond = lazy_status.has_updates,
          color = { fg = '#7e9ce4' }
        },
        {
          function()
            local status = require("copilot.api").status.data
            return (icons[status.status] or icons['']) .. (status.message or "")
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
          end
        },
        'encoding',
        'fileformat',
        { "filetype", icon_only = true, separator = "" },
      },
      lualine_z = {
        'location',
        function() return " " .. os.date("%R") end,
      }
    }
  }
}
