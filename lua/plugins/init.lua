-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  -- {
  --   'goolord/alpha-nvim',
  --   event = 'VimEnter',
  --   config = function()
  --     local alpha = require 'alpha'
  --     local dashboard = require 'alpha.themes.dashboard'
  --
  --     -- Set header
  --     dashboard.section.header.val = {
  --       '                                                     ',
  --       '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
  --       '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
  --       '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
  --       '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
  --       '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
  --       '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
  --       '                                                     ',
  --     }
  --
  --     -- Set menu
  --     dashboard.section.buttons.val = {
  --       dashboard.button('e', '  > New File', '<cmd>ene<CR>'),
  --       dashboard.button('SPC -', '  > Yazi'),
  --       dashboard.button('SPC ff', '󰱼  > Find File'),
  --       dashboard.button('SPC fg', '  > Live grep'),
  --       dashboard.button(
  --         'SPC wr',
  --         '󰁯  > Restore Session For Current Directory'
  --       ),
  --       dashboard.button('SPC lg', '  > LazyGit'),
  --       dashboard.button('q', '  > Quit NVIM', '<cmd>qa<CR>'),
  --     }
  --
  --     -- Send config to alpha
  --     alpha.setup(dashboard.opts)
  --
  --     -- Disable folding on alpha buffer
  --     vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
  --   end,
  -- }
  {
    'MysticalDevil/inlay-hints.nvim',
    event = 'LspAttach',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('inlay-hints').setup()
    end,
  },
  {
    'ThePrimeagen/vim-be-good',
  },
  'tpope/vim-fugitive',
  { 'eandrju/cellular-automaton.nvim' },
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
      'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
      -- list of formatters & linters for mason to install
      require('mason-null-ls').setup {
        ensure_installed = {
          'ruff',
          'prettier',
          'shfmt',
        },
        automatic_installation = true,
      }

      local null_ls = require 'null-ls'
      local sources = {
        require('none-ls.formatting.ruff').with {
          extra_args = { '--extend-select', 'I' },
          command = 'C:/Python313/python.exe',
        },
        require 'none-ls.formatting.ruff_format',
        null_ls.builtins.formatting.prettier.with {
          filetypes = { 'json', 'yaml', 'markdown' },
        },
        null_ls.builtins.formatting.shfmt.with { args = { '-i', '4' } },
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
        sources = sources,
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { async = false }
              end,
            })
          end
        end,
      }
    end,
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {}, -- replaces `init = function() require("flash").setup() end`
  },

  {
    'danymat/neogen',
    version = '*', -- stable versions only
    config = true, -- runs `require("neogen").setup({})`
  },
  {
    'sylvanfranklin/pear',
    config = function()
      local pear = require 'pear'
      local nmap = require('utils.map').nmap
      nmap('<leader>b', function()
        pear.jump_pair()
      end)
    end,
  },
}
