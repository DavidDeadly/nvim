return {
  {
    'numToStr/Comment.nvim',
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      "gcc", "gc", "gbc"
    },
    opts = {
      pre_hook = function() require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook() end,
    }
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  }
}
