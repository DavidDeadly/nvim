return {
  'mfussenegger/nvim-dap',
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { '<leader>db', function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
  },
  dependencies = {
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    {
      'rcarriga/nvim-dap-ui',
      keys = {
        { '<leader>du', function() require("dapui").toggle({ }) end, desc = "Dap UI" },
        { '<leader>dr', function() require("dapui").open({ reset = true }) end, desc = "Dap UI (reset)" },
        { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
      },
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup(opts)

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },

    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        automatic_installation = true,
        ensure_installed = {
          "js-debug-adapter",
          'debugpy'
        },
        handlers = {
          function(config)
            -- all sources with no handler get passed here

            -- Keep original functionality
            require('mason-nvim-dap').default_setup(config)
          end,
          js = function (config)
            config.name = 'pwa-node'

            config.adapters = {
              type = "server",
              host = "localhost",
              port = "${port}",
              executable = {
                command = "node",
                args = {
                  require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                    .. "/js-debug/src/dapDebugServer.js",
                  "${port}"
                },
              },
            }

            config.configurations = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
              },
            }

            config.filetypes = { 'javascriptreact', 'typescriptreact', 'typescript', 'javascript' }

            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
          python = function(config)
            config.adapters = {
              type = "executable",
              command = "/usr/bin/python3",
              args = {
                "-m",
                require("mason-registry").get_package("debugpy"):get_install_path() .. '/debugpy'
              },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
          end,
        },
      }
    }
  },
  opts = {},
  config = function()
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
  end,
}
