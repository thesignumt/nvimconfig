return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Global toggle for format-on-save
    vim.g.autoformat = true

    -- Setup conform
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
      -- Format on save using only the global toggle
      format_on_save = function()
        if not vim.g.autoformat then
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
        clang_format = { args = { '--style=Google' } },
      },
    }

    local m = require 'utils.map'
    local fn = require('utils.f').fn

    -- Format manually with <leader>f
    m.modes(
      'nv',
      '<leader>f',
      fn(
        require('conform').format,
        { bufnr = 0, async = true, lsp_fallback = true, timeout_ms = 1000 }
      ),
      'Format buffer or selection'
    )

    -- Toggle global format-on-save with <leader>ef
    m.nmap('<leader>ef', function()
      vim.g.autoformat = not vim.g.autoformat
      print(('autoformat: %s'):format(tostring(vim.g.autoformat)))
    end, 'Toggle format-on-save globally')
  end,
}
