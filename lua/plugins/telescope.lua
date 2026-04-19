local nmap = require('utils.map').nmap
local fn = require('utils.f').fn
return {
    { -- Telescope fuzzy finder
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = 'master',
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
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('telescope').setup {
                extensions = {
                    ['ui-select'] = require('telescope.themes').get_dropdown(),
                },
            }
            require('telescope').load_extension 'fzf'
            require('telescope').load_extension 'ui-select'

            local tb = require 'telescope.builtin'
            local maps = {
                { '<leader>sh', tb.help_tags, 'help' },
                { '<leader>sk', tb.keymaps, 'keymaps' },
                { '<leader>sf', tb.find_files, 'files' },
                { '<leader>ss', tb.builtin, 'search telescope' },
                { '<leader>sw', tb.grep_string, 'word' },
                { '<leader>sg', tb.live_grep, 'grep' },
                { '<leader>sd', tb.diagnostics, 'diagnostics' },
                { '<leader>sr', tb.resume, 'resume' },
                { '<leader>s.', tb.oldfiles, 'recent' },
                { '<leader>sb', tb.buffers, 'buffers' },
                { '<leader>sy', tb.lsp_document_symbols, 'doc symbols' },
                { '<leader>sY', tb.lsp_workspace_symbols, 'workspace symbols' },
            }
            for _, m in ipairs(maps) do
                nmap(m[1], m[2], m[3])
            end

            nmap(
                '<leader>/',
                fn(
                    tb.current_buffer_fuzzy_find,
                    require('telescope.themes').get_dropdown {
                        winblend = 10,
                        previewer = false,
                        sorting_strategy = 'ascending',
                        layout_config = { prompt_position = 'top' },
                    }
                ),
                'fzf in buffer'
            )

            nmap(
                '<leader>s/',
                fn(tb.live_grep, {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                    cwd = vim.fn.getcwd(),
                }),
                'grep in open files'
            )
            nmap('<leader>sn', fn(tb.find_files, { cwd = vim.fn.stdpath 'config' }), 'nvim conf files')
        end,
    },
}
