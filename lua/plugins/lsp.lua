return {
  { -- LSP config
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            require('utils.map').map(
              mode,
              keys,
              func,
              { buffer = event.buf, desc = 'LSP: ' .. desc }
            )
          end

          map(
            'gd',
            require('telescope.builtin').lsp_definitions,
            '[G]oto [D]efinition'
          )
          map(
            'gr',
            require('telescope.builtin').lsp_references,
            '[G]oto [R]eferences'
          )
          map(
            'gI',
            require('telescope.builtin').lsp_implementations,
            '[G]oto [I]mplementation'
          )
          map(
            'gt',
            require('telescope.builtin').lsp_type_definitions,
            'Type [D]efinition'
          )
          -- map(
          --   '<leader>ed',
          --   require('telescope.builtin').lsp_document_symbols,
          --   'document symbols'
          -- )
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- <leader>wd = builtin.lsp_dynamic_workspace_symbols
          -- <leader>th = toggle inlay hints
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = { source = 'if_many', spacing = 2 },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      local servers = {
        clangd = {},
        -- gopls = {},
        -- rust_analyzer = {},
        -- ts_ls = {},
        -- pylsp = { settings = { pylsp = { plugins = { pyflakes = { enabled = false }, ... } } } },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                disable = { 'param-type-mismatch', 'missing-fields' },
              },
              completion = { callSnippet = 'Replace' },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, { 'stylua', 'clangd' })
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend(
              'force',
              {},
              capabilities,
              server.capabilities or {}
            )
            -- require('lspconfig')[server_name].setup(server)
            vim.lsp.config(server_name, server)
          end,
        },
      }
    end,
  },
}
