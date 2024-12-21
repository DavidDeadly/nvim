return {
  {
    "numToStr/FTerm.nvim",
    opts = {
      border = "rounded",
    },
    keys = function()
      local fterm = require "FTerm"
      local lazygit = fterm:new {
        cmd = "lazygit",
        dimensions = {
          height = 0.8,
          width = 0.8,
        },
      }

      vim.api.nvim_create_user_command("LazyGit", function()
        lazygit:toggle()
      end, { bang = true })
      return {
        {
          "<M-g><M-g>",
          function()
            lazygit:toggle()
          end,
          desc = "toggle LazyGit",
        },
        {
          "<M-g><M-g>",
          function()
            lazygit:toggle()
          end,
          mode = "t",
          desc = "toggle LazyGit",
        },
        { "ñ", fterm.toggle, desc = "toggle FTerminal" },
        { "ñ", fterm.toggle, mode = "t", desc = "toggle FTerminal" },
        { "<M-c>", fterm.exit, mode = "t", desc = "toggle FTerminal" },
      }
    end,
  },
}
