return {
  'monaqa/dial.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function ()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group{
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.constant.new{
          elements = {"and", "or"},
          word = true,
          cyclic = true
        },
        augend.constant.new{
          elements = {"&&", "||"},
          word = false,
          cyclic = true,
        },
      },
      typescript = {
        augend.constant.new{ elements = {"let", "const"} },
      },
    }

    vim.keymap.set("n", "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, { desc = 'Increment with Dial' })
    vim.keymap.set("n", "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, { desc = 'Decrement with Dial' })
    vim.keymap.set("n", "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, { desc = 'Increment with Dial' })
    vim.keymap.set("n", "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, { desc = 'Decrement with Dial' })
    vim.keymap.set("v", "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, { desc = 'Increment with Dial' })
    vim.keymap.set("v", "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, { desc = 'Decrement with Dial' })
    vim.keymap.set("v", "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, { desc = 'Increment with Dial' })
    vim.keymap.set("v", "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, { desc = 'Decrement with Dial' })

    local dialSettings = vim.api.nvim_create_augroup('DialSettings', { clear = true });
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '{type,java}script',
      callback = function()
        print("javascript or typescipt file")
        vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("typescript"), { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("typescript"), { noremap = true })
      end,
      group = dialSettings,
    })
  end
}
