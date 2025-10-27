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
      -- @type snacks.Picker.Config
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
      scroll = {
        animate = {
          duration = { step = 15, total = 250 },
          easing = 'linear',
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = 'linear',
        },
        filter = function(buf)
          return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= 'terminal'
        end,
      },
      image = {
        formats = {
          'png',
          'jpg',
          'jpeg',
          'gif',
          'bmp',
          'webp',
          'tiff',
          'heic',
          'avif',
          'mp4',
          'mov',
          'avi',
          'mkv',
          'webm',
        },
        force = false,
        doc = {
          -- enable image viewer for documents
          -- a treesitter parser must be available for the enabled languages.
          -- supported language injections: markdown, html
          enabled = true,
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = false,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          max_width = 80,
          max_height = 40,
        },
        img_dirs = { 'img', 'images', 'assets', 'static', 'public', 'media', 'attachments' },
        wo = {
          wrap = false,
          number = false,
          relativenumber = false,
          cursorcolumn = false,
          signcolumn = 'no',
          foldcolumn = '0',
          list = false,
          spell = false,
          statuscolumn = '',
        },
        cache = vim.fn.stdpath('cache') .. '/snacks/image',
        debug = {
          request = false,
          convert = false,
          placement = false,
        },
        env = {},
      },
      ---@class snacks.indent.Config
      indent = {
        priority = 1,
        scope = {
          enabled = true,
          char = '┇',
          hl = 'SnacksIndentScope',
        },
        indent = {
          enabled = true,
          char = '┊',
          only_scope = false,
          only_current = false,
          hl = 'SnacksIndent',
        },
      },
    },
    keys = {
      {
        '<leader><leader>',
        function()
          Snacks.picker.files({
            layout = {
              preset = 'default',
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
