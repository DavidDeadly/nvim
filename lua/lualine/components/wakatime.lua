local Job = require "plenary.job"
local async = require "plenary.async"
local uv = require "luv"

local M = {}

local get_wakatime_time = function()
  local tx, rx = async.control.channel.oneshot()
  local ok, job = pcall(Job.new, Job, {
    command = os.getenv "HOME" .. "/.wakatime/wakatime-cli",
    args = { "--today" },
    on_exit = function(j, _)
      tx(j:result()[1] or "")
    end,
  })
  if not ok then
    vim.notify("Bad WakaTime call: " .. job, "warn")
    return ""
  end

  job:start()
  return rx()
end

---@diagnostic disable
local state = { comp_wakatime_time = "" }

-- Yield statusline value
M.today_time = function()
  local WAKATIME_UPDATE_INTERVAL = 10000

  if not Wakatime_routine_init then
    local timer = uv.new_timer()
    if timer == nil then
      return ""
    end
    -- Update wakatime every 10s
    uv.timer_start(timer, 500, WAKATIME_UPDATE_INTERVAL, function()
      async.run(get_wakatime_time, function(time)
        state.comp_wakatime_time = time
      end)
    end)
    Wakatime_routine_init = true
  end

  return state.comp_wakatime_time
end

return M
