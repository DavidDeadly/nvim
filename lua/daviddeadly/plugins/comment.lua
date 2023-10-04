return {
  {
    "echasnovski/mini.comment",
    keys = {
      "gcc", "gc"
    },
    version = "*",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    }
  },

	{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

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
