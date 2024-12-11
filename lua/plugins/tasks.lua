return {
  "stevearc/overseer.nvim",
  opts = function()
    -- NOTE: not working on summa in linux :(
    -- require("overseer.custom-builtins.summa")

    return {
      dap = false,
      templates = {
        "builtin",
        "npm",
        "cpp",
      },
    }
  end,
  keys = {
    { "<leader>R", "<CMD>OverseerRun<CR>", desc = "Run task" },
    { "<leader>rT", "<CMD>OverseerToggle right<CR>", desc = "Toggle tasks" },
  },
}
