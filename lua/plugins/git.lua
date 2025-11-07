local nmap = require('utils.map').nmap
return {
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    keys = {
      { '<leader><leader>g', '<cmd>LazyGit<cr>', desc = 'Open LazyGit' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
    },
    config = function()
      -- optional: if you want LazyGit to always open in the root of your git repo
      vim.g.lazygit_floating_window_winblend = 0 -- transparency
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'next git change' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'prev git change' })

        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git stage hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git reset hunk' })
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
      end,
    },
    config = function(_, opts)
      local gitsigns = require 'gitsigns'
      gitsigns.setup(opts)
      nmap('<leader>gh', gitsigns.preview_hunk, 'preview hunk')
      nmap('<leader>gt', gitsigns.toggle_current_line_blame, 'toggle blame')
    end,
  },
}
