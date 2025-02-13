return {
  {
    'folke/snacks.nvim',
    --- @type snacks.Config
    opts = {
      dashboard = {
        sections = {
          {
            section = 'terminal',
            -- cmd = '~/.config/nvim/scripts/header.sh ~/.config/nvim/static/header.cat',
            cmd = '~/.config/nvim/scripts/animation.sh',
            height = 14,
            indent = 16,
          },
          { section = 'keys', gap = 1, padding = 1 },
          {
            pane = 2,
            section = 'recent_files',
            icon = ' ',
            title = 'Recent Files',
            indent = 2,
            padding = { 1, 1 },
          },
          {
            pane = 2,
            section = 'projects',
            icon = ' ',
            title = 'Projects',
            indent = 2,
            padding = { 1, 1 },
          },
          {
            pane = 2,
            section = 'terminal',
            icon = ' ',
            title = 'Git Status',
            enabled = vim.fn.isdirectory('.git') == 1,
            cmd = 'hub --no-pager diff --stat -B -M -C',
            height = 10,
          },
          { pane = 2, section = 'startup' },
        },
      },
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          lsp_symbols = {
            filter = {
              vue = true,
              markdown = true,
              html = true,
            },
          },
        },
      },
      animate = {
        fps = 120,
      },
    },
    keys = {
      {
        '<leader><leader>',
        function()
          Snacks.picker.files({
            layout = {
              preset = 'select',
            },
          })
        end,
        desc = 'Files[Custom]',
      },
      {
        '<leader>;',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume[Custom]',
      },
      {
        '<leader>fl',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Lines[Custom]',
      },
      {
        '<leader>fz',
        function()
          Snacks.picker.zoxide()
        end,
        desc = 'Zoxide[Custom]',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent({
            filter = {
              cwd = true,
            },
            live = true,
          })
        end,
        desc = 'Recent (cwd)[Custom]',
      },
      {
        '<leader>fR',
        function()
          Snacks.picker.recent({
            filter = {
              cwd = false,
            },
            live = true,
          })
        end,
        desc = 'Recent (all)[Custom]',
      },
      {
        '<leader>fp',
        function()
          local folders = { '~/Work', '~/Code' }
          for _, v in ipairs(vim.fn.globpath('~/Work', '*', true, true)) do
            if vim.fn.isdirectory(v) == 1 then
              table.insert(folders, v)
            end
          end
          Snacks.picker.projects({
            finder = 'recent_projects',
            dev = folders,
            confirm = 'load_session',
          })
        end,
        desc = 'Projects[Custom]',
      },
    },
  },
}
