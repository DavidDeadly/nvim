-- luacheck: globals vim

local find_in_current_buffer = function()
	local dropdown = require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	})

	require("telescope.builtin").current_buffer_fuzzy_find(dropdown)
end

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	branch = "0.1.x",
	dependencies = { { "nvim-lua/plenary.nvim" } },
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[f]ind [f]iles" },
		{ "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "[f]ind All [F]iles" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "[f]ind [w]ord" },
		{ "<leader>fW", "<cmd>Telescope live_grep<cr>", desc = "[f]ind [W]ords" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "[f]ind [b]uffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "[f]ind [h]elp tags" },
		{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[f]ind [g]it files" },
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "[f]ind [d]iagnostics" },
		{ "<leader>fc", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "[f]ind [c]olorscheme" },
		{ "<leader>ltb", "<cmd>Telescope builtin<cr>", desc = "[l]ist [t]elescope [b]uiltin" },
		{ "<leader>ks", "<cmd>Telescope keymaps<cr>", desc = "[k]ey[m]aps" },
		{ "<leader>fr", "<cmd>Telescope resume<cr>", desc = "[r]esume telescope" },
		{ "<leader><C-space>", "<cmd>Telescope oldfiles<cr>", desc = "[?] recently open files" },
		{ "<leader><space>", "<cmd>Telescope oldfiles only_cwd=true<cr>", desc = "[?] recently open files (cwd)" },
		{ "<leader>/", find_in_current_buffer, desc = "[/] Search in current buffer" },
	},
  config = function()
    require("telescope").setup({
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
      pickers = {
        find_files = {
          prompt_prefix = "🔍 ",
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
    })

    require("telescope").load_extension("notify")
  end,
}
