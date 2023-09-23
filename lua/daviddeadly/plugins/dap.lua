local dap_icons = {
  Stopped = { "󰁕 ", "DapStopped" },
  Breakpoint = { " ", "DapBreakpoint" },
  BreakpointCondition = { " ", "DapBreakpoint" },
  BreakpointRejected = { " ", "DapBreakpoint" },
  LogPoint = { ".>", "DapLogPoint" },
}

local node_filetypes = { 'javascriptreact', 'typescriptreact', 'typescript', 'javascript' }

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

        require("overseer").patch_dap(true)
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
      "mxsdev/nvim-dap-vscode-js",
      ft = node_filetypes,
      dependencies = {
        {
          "microsoft/vscode-js-debug",
          version = "1.x",
          build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
        }
      },
      opts = {
        debugger_path = lazypath .. "/vscode-js-debug",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      },
      config = function (_, opts)
        local dap = require('dap')
        require('dap-vscode-js').setup(opts)

        for _, language in ipairs(node_filetypes) do
          if not dap.configurations[language] then

            dap.configurations[language] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = '${workspaceFolder}',
                skipFiles = { '<node_internals>/**' },
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
                skipFiles = { '<node_internals>/**' },
              },
              {
                type = "pwa-chrome",
                request = "launch",
                name = "Launch chromium",
                url = "http://localhost:4200",
                preLaunchTask = "npm: start",
                sourceMaps = true,
                webRoot = "${workspaceFolder}/code",
                protocol = "inspector",
                port = 9222,
                runtimeExecutable = "/usr/bin/vivaldi-stable",
                skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" }
              },
              {
                name = "Deno debug restricted",
                type = 'pwa-node',
                request = 'launch',
                runtimeExecutable = "deno",
                runtimeArgs = {
                  "run",
                  "--inspect-wait",
                },
                program = "${file}",
                cwd = "${workspaceFolder}",
                attachSimplePort = 9229,
              },
              {
                name = "Deno debug",
                type = 'pwa-node',
                request = 'launch',
                runtimeExecutable = "deno",
                runtimeArgs = {
                  "run",
                  "--inspect-wait",
                  "--allow-all"
                },
                program = "${file}",
                cwd = "${workspaceFolder}",
                attachSimplePort = 9229,
              }
            }
          end
        end

      end
    }

  },
  init = function ()
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(dap_icons) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[2], numhl = sign[2] }
      )
    end
  end,
}
