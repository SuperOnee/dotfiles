local M = {}

local function get_struct_name()
  local line = vim.api.nvim_get_current_line()
  return line:match('type%s+(%w+)%s+struct')
end

local function select_case(args, input_func)
  Snacks.picker.select({ 'camelcase', 'snakecase', 'pascalcase', 'default' }, {
    prompt = 'Select tag case:',
  }, function(case)
    if case and case ~= 'default' then
      table.insert(args, '-transform')
      table.insert(args, case)
      input_func()
    else
      table.insert(args, '-transform')
      table.insert(args, 'camelcase')
      input_func()
    end
  end)
end

function M.run()
  local file = vim.fn.expand('%:p')
  local struct = get_struct_name()

  if not struct then
    Snacks.notify('No struct found', { level = 'error' })
    return
  end

  local args = { '-file', file, '-struct', struct, '-w', '-override' }

  local function run_modify_tags()
    vim.fn.jobstart({ 'gomodifytags', unpack(args) }, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        if data and #data > 0 then
          Snacks.notify(table.concat(data, '\n'), { level = 'info' })
        end
      end,
      on_stderr = function(_, data)
        if data then
          local filtered = vim.tbl_filter(function(line)
            return line ~= nil and line ~= ''
          end, data)

          if #filtered > 0 then
            Snacks.notify(table.concat(filtered, '\n'), { level = 'error' })
          end
        end
      end,
      on_exit = function()
        vim.schedule(function()
          vim.cmd('edit')
          -- format when finished
          LazyVim.format({ force = true })
          Snacks.notify('Struct tags updated', { level = 'info' })
        end)
      end,
    })
  end

  Snacks.picker.select({ 'Add tags', 'Remove tags' }, {
    prompt = 'Select Mode:',
  }, function(choice)
    if not choice then
      Snacks.notify('Cancelled', { level = 'info' })
      return
    end

    if choice == 'Add tags' then
      select_case(args, function()
        Snacks.input({ prompt = 'Add tags (e.g. json,xml): ' }, function(input)
          if input and input ~= '' then
            table.insert(args, '-add-tags')
            table.insert(args, input)
          end
          run_modify_tags()
        end)
      end)
    elseif choice == 'Remove tags' then
      Snacks.input({ prompt = 'Remove tags (e.g. json,xml): ' }, function(input)
        if input and input ~= '' then
          table.insert(args, '-remove-tags')
          table.insert(args, input)
        end
        run_modify_tags()
      end)
    end
  end)
end

return M
