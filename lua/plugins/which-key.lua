return {
  "folke/which-key.nvim",
  config = true,
  keys = {
    "<leader>",
    [["]],
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
}
