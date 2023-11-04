-- luacheck: globals vim
return {
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gf", vim.cmd.Git, desc = "Git fugitive" },
		},
	},

	{
		"akinsho/git-conflict.nvim",
    cmd = { "GitConflictRefresh" },
		version = "*",
		config = true,
	},

	{
		"ThePrimeagen/git-worktree.nvim",
		opts = {},
		keys = {
			{
				"<leader>gw",
				function()
					require("telescope").extensions.git_worktree.git_worktrees()
				end,
				desc = "List git worktrees",
			},
			{
				"<leader>wc",
				function()
					require("telescope").extensions.git_worktree.create_git_worktree()
				end,
				desc = "Create git worktree",
			},
		},
		config = function(_, opts)
			require("git-worktree").setup(opts)
			require("telescope").load_extension("git_worktree")
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local stage_selected_line = function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end
				local reset_selected_line = function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end
				local full_git_blame = function()
					gs.blame_line({ full = true })
				end
				local remote_gitdiff = function()
					gs.diffthis("~")
				end

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous hunk" })

				-- Actions
				map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage hunk" })
				map("v", "<leader>hs", stage_selected_line, { desc = "Stage line" })
				map("v", "<leader>hr", reset_selected_line, { desc = "Reset line" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>hb", full_git_blame, { desc = "Full git blame line" })
				map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle current line git blame" })
				map("n", "<leader>hd", gs.diffthis, { desc = "Local git diff current buffer" })
				map("n", "<leader>hD", remote_gitdiff, { desc = "Remote git diff current buffer" })
				map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle git deletions" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
}
