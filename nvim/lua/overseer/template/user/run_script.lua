-- /home/stevearc/.config/nvim/lua/overseer/template/user/run_script.lua
return {
  name = 'run script',
  builder = function()
    local file = vim.fn.expand('%:p')
    local cmd = { file }
    if vim.bo.filetype == 'go' then
      cmd = { 'go', 'run', file }
    elseif vim.bo.filetype == 'javascript' or vim.bo.filetype == 'typescript' then
      cmd = { 'bun', file }
    elseif vim.bo.filetype == 'lua' then
      cmd = { 'lua', file }
    elseif vim.bo.filetype == 'python' then
      print('filetype: ', vim.bo.filetype)
      cmd = { 'python', file }
    end
    return {
      cmd = cmd,
      components = {
        { 'on_output_quickfix', set_diagnostics = true },
        'on_result_diagnostics',
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'sh', 'python', 'go', 'lua', 'javascript', 'typescript' },
  },
}
