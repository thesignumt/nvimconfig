return {
    {
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
            -- local nmap = require('utils.map').nmap
            -- local xmap = require('utils.map').xmap
            local modes = require('utils.map').modes
            --
            -- xmap('<leader>Re', ':Refactor extract<cr>')
            -- xmap('<leader>Rf', ':Refactor extract_to_file<cr>')
            --
            -- xmap('<leader>Rv', ':Refactor extract_var<cr>')
            --
            modes('nx', '<leader>-', ':Refactor inline_var<cr>')
            --
            -- nmap('<leader>RI', ':Refactor inline_func<cr>')
            --
            -- nmap('<leader>Rb', ':Refactor extract_block<cr>')
            -- nmap('<leader>Rbf', ':Refactor extract_block_to_file<cr>')
        end,
    },
}
