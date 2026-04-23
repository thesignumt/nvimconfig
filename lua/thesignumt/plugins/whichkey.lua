return {
    { -- Which-key for keybind hints
        'folke/which-key.nvim',
        event = 'VimEnter',
        ---@module 'which-key'
        ---@type wk.Opts
        opts = {
            delay = 1000,
            icons = { mappings = true },
            spec = {
                { '<leader>g', group = 'git' },
                { '<leader>i', group = 'info' },
                { '<leader>s', group = 'search' },
                { '<leader>t', group = 'toggleterm' },
                { '<leader>l', group = 'LSP' },
            },
        },
    },
}
