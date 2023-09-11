return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {
		defaults = {
			file_ignore_patterns = { 'node_modules' }
		},
		pickers = {
			find_files = {
				prompt_prefix = '🔍 ',
			}
		},
	},
	keys = {
		{  '<leader>ff', '<cmd>Telescope find_files<cr>', desc = '[f]ind [f]iles' },
		{  '<leader>fF', '<cmd>Telescope find_files hidden=true no_ignore=true<cr>', desc = '[f]ind All [F]iles' },
		{  '<leader>fw', '<cmd>Telescope grep_string<cr>', desc = '[f]ind [w]ord' },
		{  '<leader>fW', '<cmd>Telescope live_grep<cr>', desc = '[f]ind [W]ords' },
		{  '<leader>fb', '<cmd>Telescope buffers<cr>', desc = '[f]ind [b]uffers' },
		{  '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = '[f]ind [h]elp tags' },
		{  '<leader>fg', '<cmd>Telescope git_files<cr>', desc = '[f]ind [g]it files' },
		{  '<leader>fc', '<cmd>Telescope colorscheme<cr>', desc = '[f]ind [c]olorscheme' },
		{  '<leader>ltb', '<cmd>Telescope builtin<cr>', desc = '[l]ist [t]elescope [b]uiltin' },
		{  '<leader>ks', '<cmd>Telescope keymaps<cr>', desc = '[k]ey[m]aps' },
	},
}
