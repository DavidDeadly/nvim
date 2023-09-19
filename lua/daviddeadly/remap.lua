vim.keymap.set('n', '<M-e>', vim.cmd.Ex, { desc = '[e]xplorer' })

vim.keymap.set('n', '<M-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<M-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<M-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<M-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<M-j>', [[:m '>+1<CR>gv=gv]], { desc = 'Move down', silent = true })
vim.keymap.set('v', '<M-k>', [[:m '<-2<CR>gv=gv]], { desc = 'Move up', silent = true })

vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

vim.keymap.set('n', '<S-l>', 'zL', { desc = 'Scoll half screen to the left' })
vim.keymap.set('n', '<S-h>', 'zH', { desc = 'Scoll half screen to the right' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Keep course on lines stacking' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll half page down (keep mouse center)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll half page up (keep mouse center)' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (keep mouse center)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Prev search result (keep mouse center)' })

vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste and keep data' })

vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], { desc = 'Copy form system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Copy line to system clipboard' })

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'Delete to empty register' })

vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Normal mode' })

-- I'll make my own
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set('n', '<C-t>', '<cmd>tab split<cr>', { desc = 'Current buffer on new tab' })
vim.keymap.set('n', '<C-t><C-n>', '<cmd>tabclose<cr>', { desc = 'Close tab' })
vim.keymap.set('n', '<Tab>', '<cmd>tabnext<cr>', { desc = 'Next tab' })
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })

vim.keymap.set('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>K', '<cmd>cnext<CR>zz', { desc = 'Next quickfix list' })
vim.keymap.set('n', '<leader>J', '<cmd>cprev<CR>zz', { desc = 'Prev quickfix list' })
vim.keymap.set('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Next location list' })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Prev location list' })

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Search and replace on current buffer' })
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make executable' })
