return {
  {
    'tpope/vim-fugitive',
    keys = {
      { '<leader>gf', vim.cmd.Git, desc = 'Git fugitive' }
    }
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { '<leader>gg', vim.cmd.LazyGitCurrentFile, desc = '[G]it root directory' },
      { '<leader>gG', vim.cmd.LazyGit, desc = '[G]it current directory' },
    }
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo Stage hunk' })
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Stage line' })
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'Reset line' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = 'Full git blame line' })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle current line git blame' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'Local git diff current buffer' })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Remote git diff current buffer' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle git deletions' })

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    },
  }
}
