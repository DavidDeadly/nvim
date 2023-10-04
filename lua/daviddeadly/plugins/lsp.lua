-- luacheck: globals vim
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",

    {
      "ray-x/lsp_signature.nvim",
      opts = {},
      main = "lsp_signature",
    },

    {
      "joeveiga/ng.nvim",
      ft = { "typescript", "html" },
      keys = {
        { "<leader>gt", function() require("ng").goto_template_for_component() end, desc = "Go to angular template for component" },
        { "<leader>gC", function() require("ng").goto_component_with_template_file() end, desc = "Go component with component" },
        { "<leader>gT", function() require("ng").get_template_tcb() end, desc = "Get angular template" },
      }
    },

    {
      "nvimtools/none-ls.nvim",
      opts = function()
        local none_ls = require("null-ls")

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
            none_ls.builtins.completion.spell,
            none_ls.builtins.diagnostics.misspell,

            -- general
            none_ls.builtins.code_actions.gitsigns,
            none_ls.builtins.completion.luasnip,
            none_ls.builtins.hover.dictionary
          }
        }
      end
    },

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require("fidget").setup({})`
    { "j-hui/fidget.nvim",       tag = "legacy", opts = {} },
    { "onsails/lspkind.nvim" },

    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        {
          "SmiteshP/nvim-navic",
          opts = {
            highlight = true,
            depth_limit = 5,
            lsp = { auto_attach = true },
          },
        },
        { "MunifTanjim/nui.nvim" },
      },
      opts = { lsp = { auto_attach = true } },
      keys = {
        { "<leader>nb", "<CMD>Navbuddy<CR>", desc = "Navbuddy breadcrumbs" },
      },
    },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
  },

  config = function()
    local on_attach = function(_, bufnr)
      local signature = require("lsp_signature")
      signature.on_attach({
        bind = true, -- This is mandatory, otherwise border config won"t get registered.
        toggle_key = "<M-x>",
        toggle_key_flip_floatwin_setting = true,
        noice = true,
        handler_opts = {
          border = "rounded",
        },
      }, bufnr)

      local nmap = function(keys, func, desc, modes)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set(modes or "n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "v" })

      nmap("gd", vim.lsp.buf.definition, "[g]oto [d]efinition")
      nmap("gr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")
      nmap("gI", require("telescope.builtin").lsp_implementations, "[g]oto [I]mplementation")
      nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
      nmap("<leader>dS", require("telescope.builtin").lsp_document_symbols, "[d]ocument [s]ymbols")
      nmap("<leader>ds", require("nvim-navbuddy").open, "[w]orspaces [s]ymbols")
      nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

      -- See `:help K` for why this keymap
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<M-x>", signature.toggle_float_win, "Toggle Signature Documentation")

      nmap("<leader>vws", vim.lsp.buf.workspace_symbol, "[V]iew [W]orkspace [S]ymbols")
      nmap("<leader>vd", function()
        vim.diagnostic.open_float()
      end, "[V]iew [D]iagnostic float")
      nmap("[d", function()
        vim.diagnostic.goto_next()
      end, "Next diagnostic")
      nmap("]d", function()
        vim.diagnostic.goto_prev()
      end, "Previous diagnostic")
      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
      nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd Folder")
      nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove Folder")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[w]orkspace [l]ist Folders")

      nmap("<M-f>", "<CMD>Format<CR>", "Format file")
      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
      end, { desc = "Format current buffer with LSP" })
    end

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. They will be passed to
    --  the `settings` field of the server config. You must look up that documentation yourself.
    --
    --  If you want to override the default filetypes that your language server will attach to you can
    --  define the property "filetypes" to the map in question.

    local servers = {
      pyright = {},
      tsserver = {},
      angularls = {},
      html = { filetypes = { "html", "twig", "hbs" } },
      cssls = {},

      lua_ls = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      }
    }

    -- Setup neovim lua configuration
    require("neodev").setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    -- Ensure the servers above are installed
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        })
      end,
    })
  end,
}
