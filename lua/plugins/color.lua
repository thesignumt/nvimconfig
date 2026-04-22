return {
    {
        'thesignumt/gruber-darker.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd 'colorscheme gruber-darker'
        end,
    },

    {
        'folke/tokyonight.nvim',
        opts = {
            styles = {
                comments = { italic = false },
            },
            on_colors = function(colors) end,
            on_highlights = function(highlights, colors) end,
        },
        config = function(_, opts)
            require('tokyonight').setup(opts)
        end,
    },

    -- {
    --   'silentium-theme/silentium.nvim',
    --   lazy = false, -- ensure theme loads on startup
    --   priority = 1000, -- high priority so it loads before other colorschemes
    --   config = function()
    --     -- optional: set up custom colors
    --     require('silentium').setup {
    --       -- example: override accent color
    --       -- accent = require("silentium").accents.peach,
    --     }
    --   end,
    -- },
}
