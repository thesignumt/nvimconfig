return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        default_file_explorer = true,
        columns = {
            'icon',
            -- 'size',
            -- 'mtime',
        },
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
                return name == '..' or name == '.git'
            end,
        },
        win_options = {
            wrap = true,
        },
        float = {
            padding = 2,
            max_width = 60,
            max_height = 25,
            border = 'rounded',
        },
    },
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function(_, opts)
        require('oil').setup(opts)
        local nmap = require('utils.map').nmap
        nmap('<leader>f', ':Oil --float<cr>', { desc = 'oil' })
    end,
}
