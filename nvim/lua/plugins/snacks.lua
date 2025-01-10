return {
  {
    'snacks.nvim',
    opts = {
      dashboard = {
        sections = {
          {
            section = 'terminal',
            cmd = '~/.config/nvim/scripts/header.sh ~/.config/nvim/static/header.cat',
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
    },
  },
}
