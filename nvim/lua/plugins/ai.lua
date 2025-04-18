return {
  {
    'supermaven-inc/supermaven-nvim',
    event = 'InsertEnter',
    opts = {
      keymaps = {
        accept_suggestion = '<C-i>',
        clear_suggestion = '<C-d>',
        accept_word = '<C-j>',
      },
      ignore_filetypes = { 'bigfile', 'snacks_input', 'snacks_notif' },
      color = {
        suggestion_color = '#ffffff',
        cterm = 244,
      },
      log_level = 'info',
      disable_inline_completion = false,
      disable_keymaps = false, -- disables built in keymaps for more manual control
      condition = function()
        return false
      end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
    },
  },
  -- CodeCompanion Ai
  {
    'olimorris/codecompanion.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = function()
      -- Register custom keymaps for CodeCompanion

      vim.keymap.set('n', '<leader>aa', '<cmd>CodeCompanionChat<CR>', { desc = 'Open code companion chat[Custom]' })

      vim.keymap.set(
        { 'n', 'v' },
        '<leader>ac',
        '<cmd>CodeCompanionActions<CR>',
        { desc = 'Open code companion actions[Custom]' }
      )

      return {
        language = 'english',
        strategies = {
          chat = {
            adapter = 'gemini',
            keymaps = {
              send = {
                modes = { n = '<Enter>', i = '<C-s>' },
              },
              close = {
                modes = { n = 'Q', i = '<C-c>' },
              },
            },
          },
        },
        adapters = {
          gemini = function()
            return require('codecompanion.adapters').extend('gemini', {
              schema = {
                model = {
                  default = 'gemini-2.0-flash-lite',
                },
              },
              env = {
                api_key = 'cmd:gpg --decrypt ~/keys/gemini-api-key.gpg 2>/dev/null',
              },
            })
          end,
        },
        display = {
          diff = {
            enabled = true,
            close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
            layout = 'vertical', -- vertical|horizontal split for default provider
            opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
            provider = 'default', -- default|mini_diff
          },
        },
      }
    end,
  },
  -- Copilot
  -- {
  --   'zbirenbaum/copilot.lua',
  --   event = 'VeryLazy',
  --   cmd = 'Copilot',
  --   build = ':Copilot auth',
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       debounce = 75,
  --       keymap = {
  --         accept = '<C-i>',
  --         -- accept_word = '<C-h>',
  --         accept_line = '<C-j>',
  --         next = '<M-l>',
  --         prev = '<M-h>',
  --         dismiss = '<C-]>',
  --       },
  --     },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = false,
  --     },
  --   },
  -- },
  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   branch = 'main',
  --   cmd = 'CopilotChat',
  --   opts = function(_, opts)
  --     opts.model = 'gpt-4o'
  --     opts.sticky = {
  --       '@models Using ' .. opts.model,
  --       '#files',
  --       '#buffers',
  --     }
  --     opts.remember_as_sticky = true
  --   end,
  -- },
}
