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
          prepend_args = { '--indent-width', '2', '--column-width', '80' },
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

    m.modes('nv', '<leader>lf', function()
      require('conform').format {
        async = true,
        lsp_fallback = true,
        timeout_ms = 1000,
      }
    end, 'Format buffer or selection')

    -- Keybind: <leader>tf to toggle format-on-save globally
    m.nmap('<leader>ef', function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      vim.notify(
        'Format-on-save ' .. vim.g.disable_autoformat and 'DISABLED'
          or 'ENABLED' .. ' globally',
        vim.log.levels.INFO,
        { title = 'conform.nvim' }
      )
    end, 'Toggle format-on-save globally')

    -- Optional: buffer-local toggle command
    vim.api.nvim_create_user_command(
      'FormatToggle',
      function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
          vim.notify(
            'Format-on-save ' .. vim.b.disable_autoformat and 'DISABLED'
              or 'ENABLED' .. ' for this buffer',
            vim.log.levels.INFO,
            { title = 'conform.nvim' }
          )
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify(
            'Format-on-save ' .. vim.g.disable_autoformat and 'DISABLED'
              or 'ENABLED' .. ' globally',
            vim.log.levels.INFO,
            { title = 'conform.nvim' }
          )
        end
      end,
      { desc = 'Toggle format-on-save (add ! for buffer-local)', bang = true }
    )
  end,
}
