return {
  "echasnovski/mini.bufremove",
  -- stylua: ignore
  keys = {
    { "<C-M-i>", vim.cmd.bprevious, desc = "Previous buffer" },
    { "<C-M-o>", vim.cmd.bnext, desc = "Next buffer" },
    { "<leader>ka", "<CMD>1,$bd<CR>", desc = "Delete All Buffers" },
    { "<leader>kA", "<CMD>1,$bd!<CR>", desc = "Delete All Buffers (force)" },
    { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
    { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
  },
}
