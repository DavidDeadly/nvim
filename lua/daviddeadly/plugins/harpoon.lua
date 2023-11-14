return {
  "theprimeagen/harpoon",
  keys = {
    { "<M-a>", function() require("harpoon.mark").add_file() end, desc = "harpoon file" },
    { "<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "harpoon menu" },

    { "<M-r>", function() require("harpoon.ui").nav_file(1) end, desc = "harpoon first file" },
    { "<M-c>", function() require("harpoon.ui").nav_file(2) end, desc = "harpoon second file" },
    { "<M-y>", function() require("harpoon.ui").nav_file(3) end, desc = "harpoon third file" },
    { "<M-b>", function() require("harpoon.ui").nav_file(4) end, desc = "harpoon fourth file" },
  },
}
