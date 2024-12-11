return {
  name = "Run",
  condition = {
    filetype = { "cpp" },
    dir = "~/Dev",
  },
  tags = { require("overseer").TAG.RUN },
  builder = function()
    local output_dir = "build"
    local executable = vim.fn.getcwd() .. "/" .. output_dir .. "/" .. vim.fn.input "Executable: "

    return {
      cmd = { executable },
      components = {
        {
          "dependencies",
          task_names = {
            {
              "shell",
              cmd = "cmake -DCMAKE_BUILD_TYPE=Debug ..",
              cwd = output_dir,
            },
            {
              "shell",
              cmd = "make",
              cwd = output_dir,
            },
          },
        },
        {
          "on_output_parse",
          problem_matcher = {
            base = "$gcc",
            background = {
              beginsPattern = "Configuring done",
              endsPattern = "Built target " .. executable,
            },
          },
        },
        "default",
      },
    }
  end,
}
