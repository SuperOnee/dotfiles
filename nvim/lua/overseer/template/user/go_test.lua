-- /home/stevearc/.config/nvim/lua/overseer/template/user/go_test.lua
return {
  name = 'Go: Run Current Test Function',
  builder = function()
    local dir = vim.fn.expand('%:p:h')
    local test_name = vim.fn.expand('<cword>')
    return {
      cwd = dir,
      cmd = { 'go' },
      args = { 'test', '-v', '-run', test_name },
      name = 'Go test function: ' .. test_name,
      components = { 'default' },
    }
  end,
  condition = {
    filetype = { 'go' },
  },
}
