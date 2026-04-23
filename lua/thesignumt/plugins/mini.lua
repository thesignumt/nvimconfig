return {
    {
        'echasnovski/mini.nvim',
        config = function()
            require('mini.ai').setup { n_lines = 500 }
            require('mini.icons').setup()
            require('mini.statusline').setup { use_icons = true }

            local hipatterns = require 'mini.hipatterns'
            hipatterns.setup {
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            }
        end,
    },
}
