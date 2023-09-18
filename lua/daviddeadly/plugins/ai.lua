return {
  {
    "zbirenbaum/copilot-cmp",
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
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
