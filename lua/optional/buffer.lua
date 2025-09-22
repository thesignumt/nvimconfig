return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
    config = function(_, opts)
      require('barbar').setup(opts)

      local nmap = require('utils.map').map
      nmap('<A-,>', '<Cmd>BufferPrevious<cr>', opts)
      nmap('<A-.>', '<Cmd>BufferNext<cr>', opts)
      nmap('<A-<>', '<Cmd>BufferMovePrevious<cr>', opts)
      nmap('<A->>', '<Cmd>BufferMoveNext<cr>', opts)
      nmap('<A-p>', '<Cmd>BufferPin<cr>', opts)
      nmap('<A-c>', '<Cmd>BufferClose<cr>', opts)
    end,
  },
  -- {
  --   'akinsho/bufferline.nvim',
  --   version = '*',
  --   dependencies = 'nvim-tree/nvim-web-devicons',
  --   init = function()
  --     require('bufferline').setup {}
  --   end,
  -- },
}
