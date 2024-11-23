-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Deleting without copying, cut with X
keymap.set('n', 'x', '"_x')
keymap.set('n', 'c', '"_c')
keymap.set('n', 'C', '"_C')
keymap.set('v', 'c', '"_c')
keymap.set('v', 'C', '"_C')
keymap.set('n', 'd', '"_d')
keymap.set('n', 'D', '"_D')
keymap.set('v', 'D', '"_D')
keymap.set('v', 'd', '"_d')

-- Split windows
keymap.set('n', 'ss', ':split<CR>', opts)
keymap.set('n', 'sv', ':vsplit<CR>', opts)

-- Window Navigation
keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { remap = true, silent = true })
keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { remap = true, silent = true })
keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { remap = true, silent = true })
keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { remap = true, silent = true })

keymap.set('n', 'G', 'Gzz', { remap = true })

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Buffers
-- keymap.set('n', '<leader>bd', REMOVE_CURRENT_BUFFER, { remap = true, silent = true })

keymap.set('n', '<leader>ba', function()
  vim.cmd('BufferLineCloseOthers')
  Snacks.bufdelete()
end, { desc = 'Delete all buffers' })

-- Save file
keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })

-- Map gj gk
keymap.set('n', 'j', [[v:count?'j':'gj']], { noremap = true, expr = true })
keymap.set('n', 'k', [[v:count?'k':'gk']], { noremap = true, expr = true })

-- Select all text in current file
keymap.set('n', '<C-a>', 'gg<S-v>G')

local ls = require('luasnip')

keymap.set({ 'i', 's' }, '<C-L>', function()
  ls.jump(1)
end, opts)

keymap.set({ 'i', 's' }, '<C-H>', function()
  ls.jump(-1)
end, opts)
