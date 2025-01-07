local M = {}

local function togglePattern(patterns)
  if vim.bo.filetype ~= 'markdown' then
    return
  end
  local start_line, end_line
  if vim.fn.mode() == 'v' then
    start_line = vim.fn.line("'<")
    end_line = vim.fn.line("'>")
  else
    start_line = vim.fn.line('.')
    end_line = start_line
  end

  for i = start_line, end_line do
    local line = vim.fn.getline(i)
    for _, pattern in ipairs(patterns) do
      if line:find(pattern[1]) then
        local new_line = line:gsub(pattern[1], pattern[2])
        vim.fn.setline(i, new_line)
        break
      end
    end
  end
end

M.toggleCheckbox = function()
  togglePattern({
    { '%[ %]', '[x]' },
    { '%[x%]', '[ ]' },
  })
end

M.toggleTodo = function()
  togglePattern({
    { '%[%-%]', '[x]' },
    { '%[x%]', '[-]' },
    { '%[ %]', '[-]' },
  })
end

return M
