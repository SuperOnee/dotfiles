local term = require('snacks.terminal')
local M = {}

--- create snack terminal
---@param float boolean
local function create_snack_term(float)
  local position
  if float then
    position = 'float'
  else
    position = 'bottom'
  end
  term(nil, { cwd = LazyVim.root(), win = {
    relative = 'editor',
    position = position,
  } })
end

M.runFile = function()
  local file = vim.fn.expand('%:p')
  local ext = vim.fn.expand('%:e')
  local cmd
  if ext == 'py' then
    cmd = 'python ' .. file
  elseif ext == 'go' then
    cmd = 'go run ' .. file
  elseif ext == 'js' or ext == 'ts' then
    cmd = 'bun ' .. file
  else
    Snacks.notify.error('Unsupported file type ' .. ext)
    return
  end
  create_snack_term(true)
  vim.api.nvim_feedkeys(cmd .. '\n', 'n', true)
end

M.runServer = function()
  local cmd
  if vim.fn.glob('Makefile') ~= '' then
    cmd = 'make run'
  elseif vim.fn.glob('package.json') ~= '' then
    cmd = 'bun run dev\n'
  else
    Snacks.notify.error('No available service found')
    return
  end

  create_snack_term(false)

  vim.api.nvim_feedkeys(cmd, 'n', true)
end

M.runBuild = function()
  local cmd
  if vim.fn.glob('package.json') then
    cmd = 'bun run build'
  else
    Snacks.notify.error('No available build found')
    return
  end
  create_snack_term(false)
  vim.api.nvim_feedkeys(cmd .. '\n', 'n', true)
end

return M
