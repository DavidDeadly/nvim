local eslint_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "html"
}

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
    local cspell = require("cspell")

    local diagnostics_conf = {
      method = none_ls.methods.DIAGNOSTICS_ON_SAVE,
    }

    return {
      sources = {
        -- typescript
        none_ls.builtins.formatting.prettierd,
        -- none_ls.builtins.formatting.eslint_d,
        -- none_ls.builtins.code_actions.eslint_d,
        none_ls.builtins.formatting.eslint,
        none_ls.builtins.code_actions.eslint.with({
          filetypes = eslint_filetypes
        }),
        none_ls.builtins.diagnostics.eslint.with({
          method = none_ls.methods.DIAGNOSTICS_ON_SAVE,
          filetypes = eslint_filetypes
        }),

        -- lua
        none_ls.builtins.formatting.stylua,
        none_ls.builtins.diagnostics.luacheck.with(diagnostics_conf),

        -- python
        none_ls.builtins.diagnostics.flake8,
        none_ls.builtins.formatting.black,

        -- spelling
        none_ls.builtins.formatting.codespell,
        none_ls.builtins.diagnostics.codespell.with(diagnostics_conf),
        none_ls.builtins.diagnostics.misspell.with(diagnostics_conf),
        cspell.diagnostics.with(diagnostics_conf),
        cspell.code_actions,
        none_ls.builtins.completion.spell,

        -- general
        none_ls.builtins.code_actions.gitsigns,
        none_ls.builtins.completion.luasnip,
        none_ls.builtins.hover.dictionary
      }
    }
  end
}
