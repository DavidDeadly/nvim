local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("daviddeadly.plugins", {
  install = {
    missing = true,
    colorscheme = { 'catppuccin' },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false
  }
})

local lazy = require('lazy.util');

local function floating_terminal()
  lazy.float_term(nil, {
    size = { width = 0.8, height = 0.8 }
  })
end

local function lazy_git()
  local hasLazyGit = vim.fn.executable('lazygit') == 1;

  if hasLazyGit ~= true then
    print("Please install LazyGit to use this command")
    return
  end

  lazy.float_term('lazygit', {
    size = { width = 0.8, height = 0.8 }
  })
end

vim.keymap.set('n', '<leader>l', vim.cmd.Lazy, { desc = 'open lazy' })

vim.keymap.set('n', '<leader>ñ', floating_terminal, { desc = 'Floating terminal' })
vim.keymap.set('n', '<leader>gg', lazy_git, { desc = 'Lazygit' })
