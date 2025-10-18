local nmap = require('utils.map').nmap
local fn = require('utils.f').fn
return {
  { -- Telescope fuzzy finder
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = require('telescope.themes').get_dropdown(),
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      nmap('<leader>sh', builtin.help_tags, 'help')
      nmap('<leader>sk', builtin.keymaps, 'keymaps')
      nmap('<leader>sf', builtin.find_files, 'files')
      nmap('<leader>ss', builtin.builtin, 'search telescope')
      nmap('<leader>sw', builtin.grep_string, 'word')
      nmap('<leader>sg', builtin.live_grep, 'grep')
      nmap('<leader>sd', builtin.diagnostics, 'diagnostics')
      nmap('<leader>sr', builtin.resume, 'resume')
      nmap('<leader>s.', builtin.oldfiles, 'recent')
      nmap('<leader>sb', builtin.buffers, 'buffers')
      nmap('<leader>sy', builtin.lsp_document_symbols, 'doc symbols')
      nmap('<leader>sY', builtin.lsp_workspace_symbols, 'workspace symbols')

      nmap(
        '<leader>/',
        fn(
          builtin.current_buffer_fuzzy_find,
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
        ),
        'fzf in buffer'
      )

      nmap(
        '<leader>s/',
        fn(
          builtin.live_grep,
          { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
        ),
        'grep in open files'
      )
      nmap(
        '<leader>sn',
        fn(builtin.find_files, { cwd = vim.fn.stdpath 'config' }),
        'nvim conf files'
      )
    end,
  },
}
