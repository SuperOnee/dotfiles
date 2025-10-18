return {
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
