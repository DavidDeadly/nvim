return {
  "echasnovski/mini.indentscope",
  event = { "BufReadPost", "BufNewFile" },
  version = "*",
  opts = {
    options = { try_as_border = true }
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "lazy",
        "mason",
        "NvimTree"
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end
}
