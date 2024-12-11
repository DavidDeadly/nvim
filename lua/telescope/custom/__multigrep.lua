local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.fn.getcwd()

  local finder = finders.new_async_job {
    cwd = opts.cwd,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = {
        "rg",
      }

      if pieces[1] then
        table.insert(args, "-i")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      return vim
        .iter({
          args,
          {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
        })
        :flatten()
        :totable()
    end,
  }

  pickers
    .new(opts, {
      debounce = 100,
      finder = finder,
      prompt_title = "Multi Grep",
      previewer = conf.grep_previewer(opts),
      sorter = sorters.empty(),
    })
    :find()
end

return live_multigrep
