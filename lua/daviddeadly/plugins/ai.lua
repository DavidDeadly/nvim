return {
  {
    "zbirenbaum/copilot-cmp",
    event = 'VeryLazy',
    dependencies = {
      {
        "jonahgoldwastaken/copilot-status.nvim",
        lazy = true,
        event = "BufReadPost",
        opts = {
          icons = {
            idle = "-<",
            error = "-<",
            offline = "-<",
            warning = "-<𥉉",
            loading = "-<",
          }
        },
        config = function(_, opts)
          require("copilot_status").setup(opts)
        end,
      },
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = {
            markdown = true,
            help = true,
          },
        },
      }
    },
    opts = {
      event = { "InsertEnter", "LspAttach" },
      fix_pairs = true,
    },
    config = function(_, opts)
      require("copilot_cmp").setup(opts)
    end,
  }
}
