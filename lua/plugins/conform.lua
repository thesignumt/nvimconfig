return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Global toggle variable for format-on-save
    vim.g.disable_autoformat = false

    -- Setup conform with formatters and conditional format_on_save
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        sh = { 'shfmt' },
        go = { 'gofmt', 'goimports' },
        rust = { 'rustfmt' },
        c = { 'clang_format' },
      },
      -- Only format on save if not disabled globally or per buffer
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_fallback = true }
      end,
      formatters = {
        stylua = {
          prepend_args = {
            '--indent-type',
            'Spaces',
            '--indent-width',
            '2',
            '--column-width',
            '80',
          },
        },
        black = { prepend_args = { '--line-length', '88' } },
        prettier = {
          args = { '--single-quote', '--print-width', '80', '--tab-width', '2' },
        },
        shfmt = { prepend_args = { '-i', '2', '-ci' } },
        clang_format = {
          -- Optional: customize the style (see clang-format docs for more)
          args = { '--style=Google' },
        },
      },
    }

    local m = require 'utils.map'
    local fn = require('utils.f').fn

    m.modes(
      'nv',
      '<leader>lf',
      fn(require('conform').format, {
        async = true,
        lsp_fallback = true,
        timeout_ms = 1000,
      }),
      'Format buffer or selection'
    )

    m.nmap('<leader>ef', function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      print(('autoformat: %s'):format(tostring(not vim.g.disable_autoformat)))
    end, 'Toggle format-on-save globally')
  end,
}
