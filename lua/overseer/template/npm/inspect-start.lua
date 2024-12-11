return {
  name = "Inspect Start",
  builder = function()
    return {
      cmd = { "npm" },
      args = { "--node-options", "--inspect", "start" },
    }
  end,
  desc = "Inpect on npm start",
  tags = { require("overseer").TAG.BUILD },
  priority = 50,
  condition = {
    filetype = { "html", "typescript" },
    dir = "~/Dev",
  },
}
