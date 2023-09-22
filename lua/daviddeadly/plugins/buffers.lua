return {
  "echasnovski/mini.bufremove",
  -- stylua: ignore
  keys = {
    { "<C-M-i>", vim.cmd.bprevious, desc = "Previous buffer" },
    { "<C-M-o>", vim.cmd.bnext, desc = "Next buffer" },
    { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
    { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
  },
}
