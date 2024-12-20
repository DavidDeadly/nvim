return {
  "theprimeagen/harpoon",
  keys = {
    {
      "<M-a>",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "harpoon file",
    },
    {
      "<C-e>",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "harpoon menu",
    },

    {
      "<leader>1",
      function()
        require("harpoon.ui").nav_file(1)
      end,
      desc = "harpoon first file",
    },
    {
      "<leader>2",
      function()
        require("harpoon.ui").nav_file(2)
      end,
      desc = "harpoon second file",
    },
    {
      "<leader>3",
      function()
        require("harpoon.ui").nav_file(3)
      end,
      desc = "harpoon third file",
    },
    {
      "<leader>4",
      function()
        require("harpoon.ui").nav_file(4)
      end,
      desc = "harpoon fourth file",
    },
  },
}
