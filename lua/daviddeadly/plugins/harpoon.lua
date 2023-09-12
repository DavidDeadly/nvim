return {
  'theprimeagen/harpoon',
  config = function()
    local mark = require('harpoon.mark')
    local ui = require('harpoon.ui')

    vim.keymap.set('n', '<A-a>', mark.add_file, { desc = 'harpoon file' })
    vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = 'harpoon menu' })

    vim.keymap.set('n', '<C-1>', function() ui.nav_file(1) end, { desc = 'harpoon first file' })
    vim.keymap.set('n', '<C-2>', function() ui.nav_file(2) end, { desc = 'harpoon second file' })
    vim.keymap.set('n', '<C-3>', function() ui.nav_file(3) end, { desc = 'harpoon third file' })
    vim.keymap.set('n', '<C-4>', function() ui.nav_file(4) end, { desc = 'harpoon fourth file' })
  end,
}
