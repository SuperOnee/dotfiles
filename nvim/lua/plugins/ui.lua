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
        highlights = require('catppuccin.groups.integrations.bufferline').get(),
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
  -- filename
  -- {
  --   'b0o/incline.nvim',
  --   event = 'BufReadPre',
  --   priority = 1200,
  --   config = function()
  --     local mocha = require('catppuccin.palettes').get_palette('mocha')
  --     require('incline').setup({
  --       highlight = {
  --         groups = {
  --           InclineNormal = { guibg = mocha.yellow, guifg = mocha.base },
  --           InclineNormalNC = { guifg = mocha.yellow, guibg = mocha.base },
  --         },
  --       },
  --       window = { margin = { vertical = 0, horizontal = 1 } },
  --       hide = {
  --         cursorline = true,
  --       },
  --       render = function(props)
  --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
  --         if vim.bo[props.buf].modified then
  --           filename = '[+] ' .. filename
  --         end
  --
  --         local icon, color = require('nvim-web-devicons').get_icon_color(filename)
  --         return { { icon, guifg = color }, { ' ' }, { filename } }
  --       end,
  --     })
  --   end,
  -- },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = function(_, opts)
      local logo = [[
                                                                                  ⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀
                                                                                  ⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀
                                                                                  ⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀
                                                                                  ⠀⠀⠀⠀⠀⢸⡿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⣧⠀⠀⠀⠀⠀
              _    _ ______ _____  _____ ______ _   _ ____  ______ _____   _____   ⢀⣀⣀⣀⣀⣸⣇⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣸⣿⣀⣀⣀⣀⠀
            | |  | |  ____|_   _|/ ____|  ____| \ | |  _ \|  ____|  __ \ / ____|  ⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇
            | |__| | |__    | | | (___ | |__  |  \| | |_) | |__  | |__) | |  __   ⠀⠀⠀⠉⢙⣿⡿⠿⠿⠿⠿⠿⢿⣿⣿⣿⠿⠿⠿⠿⠿⢿⣿⣛⠉⠁⠀⠀
            |  __  |  __|   | |  \___ \|  __| | . ` |  _ <|  __| |  _  /| | |_ |     ⣰⡟⠉⢰⣶⣶⣶⣶⣶⣶⡶⢶⣶⣶⣶⣶⣶⣶⡆⠉⠻⣧⠀  
            | |  | | |____ _| |_ ____) | |____| |\  | |_) | |____| | \ \| |__| |     ⢻⣧⡀⠈⣿⣿⣿⣿⣿⡿⠁⠈⢿⣿⣿⣿⣿⣿⠁⠀⣠⡿⠀  
            |_|  |_|______|_____|_____/|______|_| \_|____/|______|_|  \_\\_____|     ⠀⠙⣿⡆⠈⠉⠉⠉⠉⠀⠀⠀⠀⠉⠉⠉⠉⠁⢰⣿⠋⠀⠀  
                                                                                      ⠀⠀⣿⡇⠀⠀⠀⣠⣶⣶⣶⣶⣶⣶⣄⠀⠀⠀⢸⣿⠀⠀⠀  
                                                                                    ⠀⠀⠀⠸⣷⡀⠀⠀⣿⠛⠉⠉⠉⠉⠛⣿⠀⠀⢀⣾⠇⠀⠀⠀⠀⠀
                                                                                    ⠀⠀⠀⠀⠘⢿⣦⡀⣿⣄⠀⣾⣷⠀⣠⣿⣀⣴⡟⠁⠀⠀⠀⠀⠀⠀
                                                                                    ⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀
                                                                                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                                                        ⠀⠀⠀⠀⠀                  
                                                                                        ⠀⠀⠀⠀⠀                  
                                                                                        ⠀⠀⠀⠀⠀                  
                                                                                        ⠀⠀⠀⠀⠀                  
                  ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'
      opts.config.header = vim.split(logo, '\n')
    end,
  },
}
