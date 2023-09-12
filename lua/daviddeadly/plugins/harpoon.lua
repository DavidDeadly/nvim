return {
  'theprimeagen/harpoon',
  keys = {
    { '<A-a>', function() require('harpoon.mark').add_file() end, desc = 'harpoon file' },
    { '<C-e>', function() require('harpoon.ui').toggle_quick_menu() end, desc = 'harpoon menu' },

    { '<C-1>', function() require('harpoon.ui').nav_file(1) end, desc = 'harpoon first file' },
    { '<C-2>', function() require('harpoon.ui').nav_file(2) end, desc = 'harpoon second file' },
    { '<C-3>', function() require('harpoon.ui').nav_file(3) end, desc = 'harpoon third file' },
    { '<C-4>', function() require('harpoon.ui').nav_file(4) end, desc = 'harpoon fourth file' },
  },
}
