-- luacheck: globals vim lazypath
local overseer = require("overseer")

local function file_exists(name)
   local f = io.open(name, "r")

  if f ~= nil then
    io.close(f)
    return true
  end

  return false
end

return {
	name = "Debug React Native",
	builder = function()
		return {
			cmd = { "node" },
			args = { "src/standalone.js" },
			name = "node react-native debug",
      cwd = lazypath .. "/nvim-dap-reactnative",
      env = {
        RN_DEBBUGER_WD = vim.fn.getcwd(),
      }
		}
	end,
	desc = "Inpect on React Native",
	tags = { overseer.TAG.BUILD },
	priority = 50,
	condition = {
		filetype = { "typescriptreact", "javascriptreact" },
		dir = "~/Dev",
		callback = function()
      local cwd = vim.fn.getcwd()

      local react_native_config = file_exists(cwd .. "/metro.config.js")

      if not react_native_config then
        return false
      end

      return true
		end,
	},
}
