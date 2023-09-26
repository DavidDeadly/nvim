return {
  {
    "theprimeagen/vim-be-good",
    cmd = "VimBeGood"
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
        "mason"
      },
    }
  },

  {
    "echasnovski/mini.move",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = {}
  },
}
