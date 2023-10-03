-- luacheck: globals vim
local lualine = require("lualine")
local Job = require("plenary.job")

return {
  "wakatime/vim-wakatime",
  event = "VeryLazy",
  config = function()
    local lualine_conf = lualine.get_config() or {}

    local wakatime = vim.api.nvim_create_augroup("Wakatime", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      group = wakatime,
      callback = function ()
        pcall(function()
          Job:new({
            command = "wakatime-cli",
            args = { "--today" },
            on_exit = function(j, return_val)
              if(return_val ~= 0) then
                return
              end

              local today_time = j:result()

              vim.schedule(function()
                local wakatime_status = {
                  function() return today_time[1] end,
                  cond = function()
                    return today_time ~= nil
                  end,
                  icon = "󰔚"
                }

                local lualine_opts = vim.tbl_deep_extend("force", lualine_conf, {
                  sections = {
                    lualine_c = vim.list_extend({ wakatime_status }, lualine_conf.sections.lualine_c),
                  }
                })

                lualine.setup(lualine_opts)
              end)
            end,
            on_stderr = function() end
          }):start()
        end)
      end,
    })
  end
}
