return {
  -- Yazi
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>e',
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = 'Resume the last yazi session',
      },
    },
    opts = {
      keymaps = {
        show_help = '<f1>',
      },
      open_for_directories = true,
      open_multiple_tabs = false,
      floating_window_scaling_factor = 0.9,
      yazi_floating_window_winblend = 0,
      log_level = vim.log.levels.OFF,
      integrations = {
        -- Integrate with snacks.picker
        grep_in_selected_files = function(selected_files)
          Snacks.notify('Grep in selected files', {
            level = 'info',
          })
          if #selected_files > 0 then
            local dirs = {}
            local globs = {}
            for _, file in ipairs(selected_files) do
              local f = tostring(file)
              -- get dir name & filename
              local dir = vim.fn.fnamemodify(f, ':h')
              local filename = vim.fn.fnamemodify(f, ':t')
              dirs[dir] = true
              table.insert(globs, filename)
            end
            Snacks.picker.grep({
              dirs = vim.tbl_keys(dirs),
              glob = globs,
            })
            local keycode = vim.keycode('i')
            vim.api.nvim_feedkeys(keycode, 'n', true)
          else
            Snacks.notify('No files selected', {
              level = 'error',
            })
          end
        end,
        grep_in_directory = function(directory)
          Snacks.notify('Grep in ' .. directory, {
            level = 'info',
          })
          local dirs = { directory }
          Snacks.picker.grep({
            finder = 'grep',
            dirs = dirs,
            ignored = false,
            hidden = true,
            focus = 'input',
            live = true,
            supports_live = true,
          })
          local keycode = vim.keycode('i')
          vim.api.nvim_feedkeys(keycode, 'n', true)
        end,
      },
    },
  },
  -- Tmux Navigator
  {
    'christoomey/vim-tmux-navigator',
    event = 'VeryLazy',
  },
  -- overseer
  {
    'stevearc/overseer.nvim',
    event = 'VeryLazy',
    opts = {
      templates = { 'builtin', 'user.run_script', 'user.go_test' },
      task_list = {
        max_height = 100,
        height = 100,
        direction = 'bottom',
      },
    },
  },
  -- Split join
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    opts = function()
      -- Register keymaps
      local tree_sj = require('treesj')
      vim.keymap.set('n', 'J', tree_sj.toggle)
      vim.keymap.set('n', 'gS', tree_sj.split)
      vim.keymap.set('n', 'gJ', tree_sj.join)
      return {
        ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,
        ---@type boolean Node with syntax error will not be formatted
        check_syntax_error = true,
        ---If line after join will be longer than max value,
        ---@type number If line after join will be longer than max value, node will not be formatted
        max_join_length = 120,
        ---Cursor behavior:
        ---hold - cursor follows the node/place on which it was called
        ---start - cursor jumps to the first symbol of the node being formatted
        ---end - cursor jumps to the last symbol of the node being formatted
        ---@type 'hold'|'start'|'end'
        cursor_behavior = 'hold',
        ---@type boolean Notify about possible problems or not
        notify = true,
        ---@type boolean Use `dot` for repeat action
        dot_repeat = true,
        ---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
        on_error = nil,
        ---@type table Presets for languages
        -- langs = {}, -- See the default presets in lua/treesj/langs
      }
    end,
  },
}
