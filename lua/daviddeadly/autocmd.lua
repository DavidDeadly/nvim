local autocmd = vim.api.nvim_create_autocmd
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

