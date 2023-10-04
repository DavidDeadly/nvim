return {
  {
    "joeveiga/ng.nvim",
      ft = { "typescript", "html" },
      keys = {
        { "<leader>gt", function() require("ng").goto_template_for_component() end, desc = "Go to angular template for component" },
        { "<leader>gC", function() require("ng").goto_component_with_template_file() end, desc = "Go component with component" },
        { "<leader>gT", function() require("ng").get_template_tcb() end, desc = "Get angular template" },
      }
  },
}
