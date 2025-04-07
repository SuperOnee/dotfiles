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
      opt.highlights = require('catppuccin.groups.integrations.bufferline').get({
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
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = function()
      local icons = LazyVim.config.icons
      vim.o.laststatus = vim.g.lualine_laststatus
      local opts = {
        options = {
          theme = 'auto',
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              'diagnostics',
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path() },
          },
          lualine_x = {
            Snacks.profiler.status(),
        -- stylua: ignore
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
        -- stylua: ignore
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = function() return { fg = Snacks.util.color("Debug") } end,
        },
        -- stylua: ignore
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = function() return { fg = Snacks.util.color("Special") } end,
        },
            {
              'diff',
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
            { 'location', padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return ' ' .. os.date('%R')
            end,
          },
        },
        extensions = { 'neo-tree', 'lazy', 'fzf' },
      }
      -- do not add trouble symbols if aerial is enabled
      -- And allow it to be overriden for some buffer types (see autocmds)
      if vim.g.trouble_lualine and LazyVim.has('trouble.nvim') then
        local trouble = require('trouble')
        local symbols = trouble.statusline({
          mode = 'symbols',
          groups = {},
          title = false,
          filter = { range = true },
          format = '{kind_icon}{symbol.name:Normal}',
          hl_group = 'lualine_c_normal',
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end

      return opts
    end,
  },
}
