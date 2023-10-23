-- luacheck: globals vim

return {
  "mbbill/undotree",
  event = "BufRead",
  keys = {
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "toggle [u]ndotree" }
  }
}
