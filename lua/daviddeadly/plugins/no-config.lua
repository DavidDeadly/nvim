return {
  {
    "theprimeagen/vim-be-good",
    cmd = "VimBeGood"
  },

  {
    "wakatime/vim-wakatime",
  },

  {
    "christoomey/vim-tmux-navigator",
  },

  {
    "m4xshen/hardtime.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disabled_filetypes = {
        "dapui_scopes",
        "dapui_breakpoints",
        "dapui_console",
        "dapui_stacks",
        "dapui_watches",
        "dapui_repl",
        "dap-float",
        "FTerm",
        "netrw",
        "lazy",
        "mason",
        "minifiles"
      },
    }
  },

  {
    "echasnovski/mini.move",
    keys = {
      { "<M-j>", mode = { "n", "v" } },
      { "<M-k>", mode = { "n", "v" } },
      { "<M-h>", mode = { "n", "v" } },
      { "<M-l>", mode = { "n", "v" } },
    },
    version = "*",
    opts = {}
  },
}
