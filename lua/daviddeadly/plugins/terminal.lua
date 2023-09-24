local function lazy_git()
  local fterm = require("FTerm")

  return fterm:new({
    cmd = "lazygit",
    dimensions = {
      height = 0.8,
      width = 0.8
    }
  })
end

return {
  "numToStr/FTerm.nvim",
  opts = function()
    local lazygit = lazy_git()
    vim.api.nvim_create_user_command("LazyGit", function() lazygit:toggle() end, { bang = true })

    return {}
  end,
  keys = {
    { "<M-g><M-g>", vim.cmd.LazyGit, desc = "toggle LazyGit" },
    { "<M-g><M-g>", "<C-\\><C-n><CMD>LazyGit<CR>", mode = "t", desc = "toggle LazyGit" },
    { "<M-ñ>", function() require("FTerm").toggle() end, desc = "toggle FTerminal" },
    { "<M-ñ>", "<C-\\><C-n><CMD>lua require('FTerm').toggle()<CR>", mode = "t", desc = "toggle FTerminal" },
    { "<M-c>", "<C-\\><C-n><CMD>lua require('FTerm').exit()<CR>", mode = "t", desc = "toggle FTerminal" },
  }
}
