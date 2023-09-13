local telescope_integration = function (_, opts)
  local hasFlash = require("lazy.core.config").spec.plugins['flash.nvim'] ~= nil;

  if not hasFlash then
    return
  end

  local function flash(prompt_bufnr)
    require("flash").jump({
      pattern = "^",
      label = { after = { 0, 0 } },
      search = {
        mode = "search",
        exclude = {
          function(win)
            return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
          end,
        },
      },
      action = function(match)
        local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        picker:set_selection(match.pos[1] - 1)
      end,
    })
  end

  opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
    mappings = {
      n = { s = flash },
      i = { ["<c-s>"] = flash },
    },
  })
end

return {
  {
    "folke/flash.nvim",
    opts = {},
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<A-s>", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "<A-S>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "<A-r>", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "<A-R>", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      { "<A-w>", function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end, desc = "Flash current word" }
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = telescope_integration
  }
}
