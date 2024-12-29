MiniIconsSetup = function(_, opts)
  require("mini.icons").setup(opts)
  MiniIcons.mock_nvim_web_devicons()
end

return {
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "echasnovski/mini.icons", config = MiniIconsSetup },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_files = true,
      keymaps = {
        ["h"] = "actions.parent",
        ["l"] = "actions.select",
      },
      view_options = {
        show_hidden = false,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
      },
      win_options = {
        wrap = true,
      },
      float = {
        padding = 5,
        max_width = 80,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
    },
    keys = {
      {
        "<leader>O",
        function()
          require("oil").open()
        end,
        desc = "open [O]il file explorer",
      },
      {
        "<leader>o",
        function()
          require("oil").open_float()
        end,
        desc = "open [o]il float file explorer",
      },
    },
  },
}
