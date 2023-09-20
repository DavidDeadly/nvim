return {
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    version = '*',
    opts = {}
  },

  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {
      input = {
        enabled = false
      }
    },
  },

   {
    'folke/noice.nvim',
    event = 'VeryLazy',
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
        }
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      { 'MunifTanjim/nui.nvim' },

      {
        'rcarriga/nvim-notify',
        opts = {
          background_colour = '#000000',
          stages = 'fade',
          render = 'compact'
        }
        ,
        keys =  {
          { "<leader>nd", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss all Notifications", },
        },
      }
    }
  },

  {
    'gen740/SmoothCursor.nvim',
    event = 'VeryLazy',
    init = function ()
      local autocmd = vim.api.nvim_create_autocmd

      autocmd({ 'ModeChanged' }, {
        callback = function()
          local current_mode = vim.fn.mode()
          if current_mode == 'n' then
            vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#8aa872' })
            vim.fn.sign_define('smoothcursor', { text = '' })
          elseif current_mode == 'v' then
            vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
            vim.fn.sign_define('smoothcursor', { text = '' })
          elseif current_mode == 'V' then
            vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
            vim.fn.sign_define('smoothcursor', { text = '' })
          elseif current_mode == '' then
            vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#bf616a' })
            vim.fn.sign_define('smoothcursor', { text = '' })
          elseif current_mode == 'i' then
            vim.api.nvim_set_hl(0, 'SmoothCursor', { fg = '#668aab' })
            vim.fn.sign_define('smoothcursor', { text = '' })
          end
        end,
      })
    end,
    opts = {
      fancy = {
        enable = true,
      },
      flyin_effect = 'top',
      speed = 1
    }
  }
}
