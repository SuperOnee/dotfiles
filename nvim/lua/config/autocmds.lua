-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local markdown_group = vim.api.nvim_create_augroup('markdown_keymap', { clear = true })

local golang_group = vim.api.nvim_create_augroup('golang_keymap', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = markdown_group,
  pattern = { 'markdown' },
  callback = function()
    require('custom.markdown_util')
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
      ":lua require('custom.markdown_util').toggleCheckbox()<CR>",
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
      ":lua require('custom.markdown_util').toggleTodo()<CR>",
      { noremap = true, silent = true, desc = 'Toggle todo' }
    )
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = golang_group,
  pattern = 'go',
  callback = function()
    vim.api.nvim_buf_set_keymap(
      0,
      'n',
      '<leader>ct',
      ":lua require('custom.go_modify_tags').run()<CR>",
      { noremap = true, silent = true, desc = 'Modify Go struct tags' }
    )
    vim.api.nvim_buf_create_user_command(0, 'GoModifyTags', function()
      require('custom.go_modify_tags').run()
    end, { desc = 'Modify Go struct tags' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = {
    'CodeCompanionRequestStarted',
    'CodeCompanionRequestFinished',
  },
  callback = function(args)
    local M = require('custom.code_companion_loading')
    if args.match == 'CodeCompanionRequestStarted' then
      M.start_spinner()
    elseif args.match == 'CodeCompanionRequestFinished' then
      M.stop_spinner()
    end
  end,
})
