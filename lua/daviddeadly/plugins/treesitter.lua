-- luacheck: globals vim rainbow_delimiters
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",

    "nvim-treesitter/nvim-treesitter-context",

    "windwp/nvim-ts-autotag",

    {
      "HiPhish/rainbow-delimiters.nvim",
      opts =  function()
        local rainbow_delimiters = require 'rainbow-delimiters';

        return {
          strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            commonlisp = rainbow_delimiters.strategy['local'],
          },
          query = {
            [''] = 'rainbow-delimiters',
            latex = 'rainbow-blocks',
          },
          highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
          },
          blacklist = {'c', 'cpp'},
        }
      end,
      config = function (_, opts)
        require"rainbow-delimiters.setup"(opts)
      end
    }
  },
  build = ":TSUpdate",
  ---@type TSConfig
  opts = {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { "lua", "python", "tsx", "javascript", "typescript", "vimdoc", "vim" },
    modules = {},

    autotag = {
      enable = true,
    },

    sync_install = false,
    auto_install = true,
    ignore_install = {},

    indent = { enable = true },

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = "<C-s>",
        node_decremental = "<C-backspace>",
      },
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ii"] = "@conditional.inner",
          ["ai"] = "@conditional.outer",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  },
  config = function (_, opts)
     require("nvim-treesitter.configs").setup(opts)
  end
}
