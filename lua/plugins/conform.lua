return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      sh = { 'shfmt' },
      go = { 'gofmt', 'goimports' },
      rust = { 'rustfmt' },
      c = { 'clang_format' },
    },

    format_on_save = function()
      if not vim.g.autoformat then
        return
      end
      return { timeout_ms = 1500, lsp_fallback = true }
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

      prettier = {
        args = {
          '--single-quote',
          '--print-width',
          '80',
          '--tab-width',
          '2',
        },
      },

      shfmt = {
        prepend_args = { '-i', '2', '-ci' },
      },

      clang_format = {
        args = { '--style=Google' },
      },
    },
  },

  config = function(_, opts)
    vim.g.autoformat = true

    require('conform').setup(opts)

    local m = require 'utils.map'

    m.nmap('<leader>2', function()
      vim.g.autoformat = not vim.g.autoformat
      print(('autoformat: %s'):format(tostring(vim.g.autoformat)))
    end, 'toggle format on save')
  end,
}
