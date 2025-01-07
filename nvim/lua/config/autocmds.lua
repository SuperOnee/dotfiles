-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local markdown_group = vim.api.nvim_create_augroup('markdown_keymap', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = markdown_group,
  pattern = { 'markdown' },
  callback = function()
    require('custom.markdownUtil')
    print('markdown file detected')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = markdown_group,
  pattern = 'markdown',
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      '<C-;>',
      ":lua require('custom.markdownUtil').toggleCheckbox()<CR>",
      { noremap = true, silent = true, desc = 'Toggle checkbox' }
    )
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = markdown_group,
  pattern = 'markdown',
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      '<C-,>',
      ":lua require('custom.markdownUtil').toggleTodo()<CR>",
      { noremap = true, silent = true, desc = 'Toggle todo' }
    )
  end,
})
