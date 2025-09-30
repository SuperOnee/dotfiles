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
      log_level = 'error',
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

      vim.keymap.set('n', '<leader>aa', function()
        require('codecompanion').toggle()
      end, { desc = 'Open code companion chat[Custom]' })

      vim.keymap.set(
        { 'n', 'v' },
        '<leader>ao',
        '<cmd>CodeCompanionActions<CR>',
        { desc = 'Open code companion actions[Custom]' }
      )

      local api_key = os.getenv('GEMINI_API_KEY')

      return {
        log_level = 'DEBUG',
        language = 'English',
        prompt_library = {
          ['Optimize code'] = {
            strategy = 'chat',
            description = 'Code Optimization',
            prompts = {
              {
                role = 'system',
                content = 'You are an expert code optimizer and refactorer. Analyze the code provided by the user, identify areas for improvement in terms of efficiency, readability, and maintainability, and provide a refactored version of the code with clear explanations of the changes made.',
              },
              {
                role = 'user',
                content = 'Analyze and refactor the provided code to improve its efficiency, readability, and maintainability. Provide the optimized code and explain the changes.',
              },
            },
          },
          ['Generate comments'] = {
            strategy = 'chat',
            description = 'Code Comments',
            prompts = {
              {
                role = 'system',
                content = 'You are an expert code commenter. Analyze the provided code, identify areas for improvement in terms of readability and maintainability, and provide clear and concise comments to improve the code.',
              },
              {
                role = 'user',
                content = 'Analyze and generate comments for the provided code to improve its readability and maintainability. Provide the comments and explain the changes.',
              },
            },
          },
        },
        strategies = {
          chat = {
            adapter = 'gemini',
            keymaps = {
              send = {
                modes = { n = '<Enter>' },
              },
              close = {
                modes = { n = 'Q', i = '<C-c>' },
              },
            },
          },
          inline = {
            adapter = 'gemini',
            keymaps = {
              accept_change = {
                modes = { n = 'ga' },
                description = 'Accept the suggested change',
              },
              reject_change = {
                modes = { n = 'gr' },
                description = 'Reject the suggested change',
              },
            },
          },
          cmd = {
            adapter = 'gemini',
          },
        },
        adapters = {
          gemini = function()
            return require('codecompanion.adapters').extend('gemini', {
              name = 'gemini',
              env = {
                api_key = api_key,
              },
            })
          end,
        },
        display = {
          chat = {
            show_settings = false,
          },
          diff = {
            layout = 'vertical', -- vertical|horizontal split for default provider
            provider = 'mini_diff', -- default|mini_diff
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
