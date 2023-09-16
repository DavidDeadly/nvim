local today_time_to_lualine = function(j, return_val)
  if(return_val ~= 0) then
    return
  end

  local today_time = j:result()

  vim.schedule(function()
    require('lualine').setup({
      sections = {
        lualine_c = {
          {
            function() return today_time[1] end,
            cond = function()
              return today_time ~= nil
            end,
            icon = '󰔚'
          }
        }
      }
    })
  end)
end

local call_wakatime = function()
  local Job = require('plenary.job')

  pcall(function()
    Job:new({
      command = 'wakatime-cli',
      args = { '--today' },
      on_exit = today_time_to_lualine,
      on_stderr = function() end
    }):start()
  end)
end

return {
  'wakatime/vim-wakatime',
  event = 'VeryLazy',
  init = function ()
    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
      callback = call_wakatime,
    })
  end
}
