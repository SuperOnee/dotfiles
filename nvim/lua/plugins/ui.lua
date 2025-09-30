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
  -- buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = function(_, opt)
      local mocha = require('catppuccin.palettes').get_palette('mocha')
      opt.highlights = require('catppuccin.special.bufferline').get_theme({
        styles = { 'italic', 'bold', 'underline' },
        custom = {
          mocha = {
            background = { fg = mocha.text, sp = mocha.red },
            tab_selected = {
              fg = mocha.green,
              underline = true,
            },
            indicator_selected = {
              bold = true,
              underline = true,
            },
            buffer_selected = {
              fg = mocha.green,
              bold = true,
              italic = true,
              underline = true,
            },
          },
        },
      })
      opt.options.indicator = {
        style = 'underline',
      }

      opt.options.separator_style = 'none'
      opt.options.show_buffer_close_icons = false
      opt.options.always_show_bufferline = true
    end,
    -- opts = {
    --   highlights = require('catppuccin.groups.integrations.bufferline').get({
    --     styles = { 'italic', 'bold' },
    --     custom = {
    --       all = {
    --         fill = { bg = '#000000' },
    --       },
    --       mocha = {
    --         background = { fg = mocha.text },
    --       },
    --       latte = {
    --         background = { fg = '#000000' },
    --       },
    --     },
    --   }),
    --   options = {
    --     -- separator_style = 'slope',
    --     -- mode = 'tabs',
    --     show_buffer_close_icons = false,
    --     always_show_bufferline = true,
    --     showkj_close_icon = false,
    --   },
    -- },
  },
  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function(_, opts)
      -- Add supermaven status component
      local api = require('supermaven-nvim.api')
      local function supermaven_icon()
        return LazyVim.config.icons.kinds.Supermaven
      end
      local colors = require('catppuccin.palettes').get_palette('mocha')
      table.insert(opts.sections.lualine_x, 2, {
        supermaven_icon,
        color = function()
          local is_running = api.is_running()
          if is_running then
            return { fg = colors.green }
          else
            return { fg = colors.red }
          end
        end,
      })
      -- Overseer status component
      table.insert(opts.sections.lualine_x, 3, { 'overseer' })
    end,
  },
}
