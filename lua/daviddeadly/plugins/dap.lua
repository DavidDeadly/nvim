local dap_icons = {
  Stopped = { "󰁕 ", "DapStopped" },
  Breakpoint = { " ", "DapBreakpoint" },
  BreakpointCondition = { " ", "DapBreakpoint" },
  BreakpointRejected = { " ", "DapBreakpoint" },
  LogPoint = { ".>", "DapLogPoint" },
}

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

  },
  opts = {},
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
  config = function()
    local dap = require("dap")

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "127.0.0.1",
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

    local node_filetypes = { 'javascriptreact', 'typescriptreact', 'typescript', 'javascript' }
    for _, language in ipairs(node_filetypes) do
      if not dap.configurations[language] then

        dap.configurations[language] = {
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
            skipFiles = { "<node_internals>/**" },
            cwd = "${workspaceFolder}",
          }
        }
      end
    end
  end,
}
