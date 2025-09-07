return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  opts = {},
  config = function(_, opts)
    local refactoring = require 'refactoring'
    refactoring.setup(opts)
    local nmap = require('utils.map').nmap
    local xmap = require('utils.map').xmap
    local modes = require('utils.map').modes

    xmap('<leader>re', ':Refactor extract<cr>')
    xmap('<leader>rf', ':Refactor extract_to_file<cr>')

    xmap('<leader>rv', ':Refactor extract_var<cr>')

    modes('nx', '<leader>ri', ':Refactor inline_var<cr>')

    nmap('<leader>rI', ':Refactor inline_func<cr>')

    nmap('<leader>rb', ':Refactor extract_block<cr>')
    nmap('<leader>rbf', ':Refactor extract_block_to_file<cr>')
  end,
}
