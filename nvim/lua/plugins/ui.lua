return {
  -- messages, cmdline and the popupmenu
  {
    'folke/noice.nvim',
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = 'notify',
          find = 'No information available',
        },
        opts = { skip = true },
      })
      -- REMOVE THIS once this issue is fixed: https://github.com/yioneko/vtsls/issues/159
      table.insert(opts.routes, {
        filter = {
          event = 'notify',
          find = 'Request textDocument*',
        },
        opts = { skip = true },
      })
      -- Suppress volar quit warning
      -- table.insert(opts.routes, {
      --   filter = {
      --     event = 'notify',
      --     find = 'Client volar quit with exit code 1',
      --   },
      --   opts = { skip = true },
      -- })

      local focused = true
      vim.api.nvim_create_autocmd('FocusGained', {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd('FocusLost', {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = 'notify_send',
        opts = { stop = false },
      })
      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = 'split',
          opts = { enter = true, format = 'details' },
          filter = {},
        },
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function(event)
          vim.schedule(function()
            require('noice.text.markdown').keys(event.buf)
          end)
        end,
      })
      opts.presets.lsp_doc_border = true
    end,
  },
  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 5000,
    },
  },
  -- buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        -- separator_style = 'slope',
        -- mode = 'tabs',
        show_buffer_close_icons = false,
        always_show_bufferline = true,
        show_close_icon = false,
      },
    },
  },
  {
    'echasnovski/mini.animate',
    recommended = true,
    event = 'VeryLazy',
    opts = {
      scroll = { enable = false },
      open = { enable = false },
      close = { enable = false },
    },
  },
  -- dashboard
  {
    'folke/snacks.nvim',
    opts = {
      dashboard = {
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'startup' },
          {
            section = 'terminal',
            cmd = 'pokemon-colorscripts -n charizard --no-title; sleep .1',
            random = 30,
            pane = 2,
            indent = 8,
            height = 30,
          },
        },
      },
    },
  },
}
