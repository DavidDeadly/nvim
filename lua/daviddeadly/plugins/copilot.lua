return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        auto_trigger = true
      },
      panel = { enabled = false },
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    enabled = false,
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
