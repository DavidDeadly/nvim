return {
  name = "Make project",
  condition = {
    filetype = { "cpp" },
    dir = "~/Dev",
  },
  tags = { require("overseer").TAG.BUILD },
  builder = function()
    return {
      cmd = { "make" },
      name = "Make project",
      cwd = vim.fn.getcwd() .. "/build",
      components = {
        {
          "on_output_quickfix",
          open = true,
        },
        "default",
      },
    }
  end,
}
