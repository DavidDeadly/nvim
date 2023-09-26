-- luacheck globals vim
local find_in_current_buffer = function ()
  local dropdown = require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  }

  require("telescope.builtin").current_buffer_fuzzy_find(dropdown)
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  opts = {
    defaults = {
      file_ignore_patterns = { "node_modules" },
      mappings = {
        i = {
          ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
          ["<M-h>"] = "which_key"
        },
        n = {
          ["<M-p>"] = require("telescope.actions.layout").toggle_preview
        },
      },
      preview = {
        hide_on_startup = true
      },
    },
    pickers = {
      find_files = {
        prompt_prefix = "🔍 ",
      },
    },
    extensions = {
      file_browser = {
        hijack_netrw = true,
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
          },
        },
        sorting_strategy = "ascending",
      },
    },
  },
  dependencies = {
    { "nvim-lua/plenary.nvim" },

    {
      "ahmedkhalf/project.nvim",
      main = "project_nvim",
      keys = {
        { "<leader>fp", function() require("telescope").extensions.projects.projects() end, desc = "Projects" },
      },
    },

    {
      "nvim-telescope/telescope-dap.nvim",
      keys = {
        { "<leader>DB", function() require("telescope").extensions.dap.list_breakpoints() end, desc = "Dap - Breakpoints" },
        { "<leader>dv", function() require("telescope").extensions.dap.variables() end, desc = "Dap - Variables" },
        { "<leader>df", function() require("telescope").extensions.dap.frames() end, desc = "Dap - Frames" },
        { "<leader>DC", function() require("telescope").extensions.dap.commands() end, desc = "Dap - Commands" },
      }
    },

    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "antosha417/nvim-lsp-file-operations" },
      keys = {
        { "<leader>fE", function() require("telescope").extensions.file_browser.file_browser() end, desc = "[f]ind [e]xplorer" },
        { "<leader>fe", function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = vim.fn.expand("%:p:h"),
            select_buffer = true,
            respect_git_ignore = false,
            grouped = true,
            hidden = true,
          })
        end, desc = "[f]ind [e]xplorer on current buffer" }
      },
    }
  },
  config = function (_, opts)
    require("telescope").setup(opts)

    require("telescope").load_extension("dap")
    require("telescope").load_extension("notify")
    require("telescope").load_extension("projects")
    require("telescope").load_extension("file_browser")
  end,
  keys = {
    {  "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[f]ind [f]iles" },
    {  "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "[f]ind All [F]iles" },
    {  "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "[f]ind [w]ord" },
    {  "<leader>fW", "<cmd>Telescope live_grep<cr>", desc = "[f]ind [W]ords" },
    {  "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "[f]ind [b]uffers" },
    {  "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "[f]ind [h]elp tags" },
    {  "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[f]ind [g]it files" },
    {  "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "[f]ind [d]iagnostics" },
    {  "<leader>fc", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "[f]ind [c]olorscheme" },
    {  "<leader>ltb", "<cmd>Telescope builtin<cr>", desc = "[l]ist [t]elescope [b]uiltin" },
    {  "<leader>ks", "<cmd>Telescope keymaps<cr>", desc = "[k]ey[m]aps" },
    {  "<leader>fr", "<cmd>Telescope resume<cr>", desc = "[r]esume telescope" },
    {  "<leader><C-space>", "<cmd>Telescope oldfiles<cr>", desc = "[?] recently open files" },
    {  "<leader><space>", "<cmd>Telescope oldfiles only_cwd=true<cr>", desc = "[?] recently open files (cwd)" },
    {  "<leader>/", find_in_current_buffer, desc = "[/] Search in current buffer" },
  },
}
