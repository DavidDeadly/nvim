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
      disabled_filetypes = { "FTerm", "netrw", "lazy", "mason" },
    }
  },

  {
    "echasnovski/mini.move",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = {}
  },
}
