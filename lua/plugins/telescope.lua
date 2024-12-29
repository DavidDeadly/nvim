return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "echasnovski/mini.icons", config = MiniIconsSetup },
  },
  keys = function()
    local builtin = require "telescope.builtin"

    return {
      { "<leader>ff", builtin.find_files, desc = "[f]ind [f]iles" },
      { "<leader>fw", builtin.grep_string, desc = "[f]ind [w]ord" },
      { "<leader>fW", require("telescope.custom").live_multigrep, desc = "[f]ind [W]ords" },
      { "<leader>fh", builtin.help_tags, desc = "[f]ind [h]elp tags" },
      { "<leader>fg", builtin.git_files, desc = "[f]ind [g]it files" },
      { "<leader>ltb", builtin.builtin, desc = "[l]ist [t]elescope [b]uiltin" },
      { "<leader>ks", builtin.keymaps, desc = "[k]ey[m]aps" },
      { "<leader>fr", builtin.resume, desc = "[r]esume telescope" },
      { "<leader>f.", builtin.buffers, desc = "[F]ind existing buffers" },
      { "<leader>fd", builtin.diagnostics, desc = "[f]ind [d]iagnostics" },
      { "<leader><C-space>", builtin.oldfiles, desc = "[?] Global recently open files" },
      { "<leader>/", builtin.current_buffer_fuzzy_find, desc = "[/] Search in current buffer" },
      {
        "<leader>fc",
        function()
          builtin.colorscheme { enable_preview = true }
        end,
        desc = "[f]ind [c]olorscheme",
      },
      {
        "<leader>fF",
        function()
          builtin.find_files { hidden = true }
        end,
        desc = "[f]ind All [F]iles",
      },
      {
        "<leader><space>",
        function()
          builtin.oldfiles { only_cwd = true }
        end,
        desc = "[?] CWD recently open files",
      },
      {
        "<leader>sn",
        function()
          builtin.find_files {
            cwd = vim.fn.stdpath "config",
          }
        end,
        desc = "[S]earch [N]eovim files",
      },
      {
        "<leader>s/",
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          }
        end,
        desc = "[/] Search in current buffer",
      },
      {
        "<leader>ep",
        function()
          builtin.find_files {
            cwd = LAZY_PATH,
          }
        end,
        desc = "[e]dit [p]ackages",
      },
    }
  end,
  opts = {
    defaults = {
      file_ignore_patterns = { "node_modules" },
      mappings = {
        i = {
          ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
          ["<M-h>"] = "which_key",
        },
        n = {
          ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
        },
      },
      -- preview = {
      --   hide_on_startup = true
      -- },
    },
    extensions = {
      fzf = {},
    },
    pickers = {
      find_files = {
        prompt_prefix = "🔍 ",
      },
      current_buffer_fuzzy_find = {
        winblend = 10,
        previewer = false,
        theme = "dropdown",
      },
      buffers = {
        prompt_prefix = "📁 ",
        mappings = {
          n = {
            ["d"] = require("telescope.actions").delete_buffer,
          },
          i = {
            ["<C-S-D>"] = require("telescope.actions").delete_buffer,
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("telescope").load_extension "fzf"

    require("telescope").setup(opts)
  end,
}
