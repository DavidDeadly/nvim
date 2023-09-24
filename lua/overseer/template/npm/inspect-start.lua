local overseer = require("overseer")

return {
  name = "Inspect Start",
  builder = function()
    return {
      cmd = { "npm" },
      args = { "--node-options", "--inspect", "start" },
      name = "node --inspect start",
      components = {
        {
          "on_output_parse",
          problem_matcher = {
            base = "$tsc",
            background = {
              beginsPattern = "ng serve",
              endsPattern = "Compiled successfully",
            }
          },
        },
        {
          "on_exit_set_status",
          success_codes = { 0 }
        }
      }
    }
  end,
  desc = "Inpect on npm start",
  tags = { overseer.TAG.BUILD },
  priority = 50,
  condition = {
    filetype = { "html", "typescript" },
    dir = "~/Dev",
    -- Arbitrary logic for determining if task is available
    -- callback = function(search)
    --   print(vim.inspect(search))
    --   return true
    -- end,
  },
}
