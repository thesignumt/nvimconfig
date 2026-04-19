return {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        formatters_by_ft = {
            lua = { 'stylua' },
            python = { 'ruff_format' },
            c = { 'clang_format' },
        },

        format_on_save = function(bufnr)
            if not vim.g.autoformat then
                return
            end
            return { timeout_ms = 1500, lsp_fallback = true, bufnr = bufnr }
        end,

        formatters = {
            stylua = {
                prepend_args = {
                    '--indent-type',
                    'Spaces',
                    '--indent-width',
                    '4',
                    '--column-width',
                    '80',
                },
            },

            clang_format = {
                args = { '--style={IndentWidth: 4, TabWidth: 4, UseTab: Never}' },
            },
        },
    },

    config = function(_, opts)
        vim.g.autoformat = true

        require('conform').setup(opts)

        vim.keymap.set('n', '<leader>2', function()
            vim.g.autoformat = not vim.g.autoformat
            print(('autoformat: %s'):format(tostring(vim.g.autoformat)))
        end, { desc = 'toggle format on save' })
    end,
}
