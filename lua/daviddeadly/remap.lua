-- luacheck: globals vim ExecuteMacroOverVisualRange
vim.keymap.set("n", "<M-e>", vim.cmd.Ex, { desc = "Explorer" })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

vim.keymap.set("n", "<S-u>", "zL", { desc = "Scroll half screen to the left" })
vim.keymap.set("n", "<S-d>", "zH", { desc = "Scroll half screen to the right" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Keep course on lines stacking" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down (keep mouse center)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up (keep mouse center)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (keep mouse center)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (keep mouse center)" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste and keep data" })
vim.keymap.set({ "n", "x" }, "<C-M-p>", [["+p]], { desc = "Paste form system clipboard front cursor" })
vim.keymap.set({ "n", "x" }, "<C-M-S-p>", [["+P]], { desc = "Paste form system clipboard behind cursor" })

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Copy form system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to empty register" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Normal mode" })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>K", "<cmd>cnext<CR>zz", { desc = "Next quickfix list" })
vim.keymap.set("n", "<leader>J", "<cmd>cprev<CR>zz", { desc = "Prev quickfix list" })
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev location list" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace on current buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })

vim.keymap.set('x', '@', [[:<C-u>lua ExecuteMacroOverVisualRange()<CR>]], { noremap = true, silent = true })

function ExecuteMacroOverVisualRange()
  vim.api.nvim_out_write('@' .. vim.fn.getcmdline() .. '\n')
  vim.api.nvim_exec(":'<,'>normal @" .. vim.fn.nr2char(vim.fn.getchar()), true)
end
