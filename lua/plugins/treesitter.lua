return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'master',
        build = ':TSUpdate',
        opts = {
            ensure_installed = {
                'python',
                'bash',
                'c',
                'cpp',
                'diff',
                'html',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
                'yaml',
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true, disable = { 'ruby', 'c' } },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'gnn',
                    node_incremental = 'grn',
                    scope_incremental = 'grc',
                    node_decremental = 'grm',
                },
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
}
