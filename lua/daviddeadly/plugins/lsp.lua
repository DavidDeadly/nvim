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
      "creativenull/efmls-configs-nvim",
      version = "v1.x.x", -- tag is optional, but recommended
    },

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
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
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        toggle_key = "<C-k>",
        toggle_key_flip_floatwin_setting = true,
        noice = true,
        handler_opts = {
          border = "rounded",
        },
      }, bufnr)

      -- if client.server_capabilities.documentSymbolProvider then
      --   navic.attach(client, bufnr)
      -- end

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
      nmap("<C-k>", signature.toggle_float_win, "Toggle Signature Documentation")

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
    --  define the property 'filetypes' to the map in question.
    local eslint_d = require("efmls-configs.linters.eslint_d")
    local prettier_d = require("efmls-configs.formatters.prettier_d")
    local luacheck = require("efmls-configs.linters.luacheck")
    local stylua = require("efmls-configs.formatters.stylua")

    local languages = {
      typescript = { eslint_d, prettier_d },
      javascript = { eslint_d, prettier_d },
      jsx = { eslint_d, prettier_d },
      tsx = { eslint_d, prettier_d },
      lua = { stylua, luacheck },
    }

    local servers = {
      pyright = {},
      tsserver = {},
      html = { filetypes = { "html", "twig", "hbs" } },

      lua_ls = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },

      efm = {
        filetypes = vim.tbl_keys(languages),
        settings = {
          rootMarkers = { ".git/" },
          languages = languages,
        },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
          hover = true,
          codeAction = true,
          completion = true,
        },
      },
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
        if server_name == "efm" then
          require("lspconfig")[server_name].setup(vim.tbl_extend("force", servers[server_name], {
            on_attach = on_attach,
            capabilities = capabilities,
          }))

          return
        end

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
