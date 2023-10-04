return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "davidmh/cspell.nvim"
    }
  },
  opts = function()
    local none_ls = require("null-ls")
    local cspell = require('cspell')

    return {
      sources = {
        -- typescript
        none_ls.builtins.formatting.prettierd,
        none_ls.builtins.formatting.eslint_d,
        none_ls.builtins.code_actions.eslint_d,
        none_ls.builtins.diagnostics.eslint_d,

        -- lua
        none_ls.builtins.formatting.stylua,
        none_ls.builtins.diagnostics.luacheck,

        -- spelling
        none_ls.builtins.formatting.codespell,
        none_ls.builtins.diagnostics.codespell,
        none_ls.builtins.diagnostics.misspell,
        none_ls.builtins.completion.spell,
        cspell.diagnostics,
        cspell.code_actions,

        -- general
        none_ls.builtins.code_actions.gitsigns,
        none_ls.builtins.completion.luasnip,
        none_ls.builtins.hover.dictionary
      }
    }
  end
}
