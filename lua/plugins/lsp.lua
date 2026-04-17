return {
  { -- LSP config
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        ---@module 'mason.settings'
        ---@type MasonSettings
        opts = {},
      },
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
        underline = false,
        virtual_text = {
          severity = {
            min = vim.diagnostic.severity.ERROR,
          },
          spacing = 2,
          source = 'if_many',
        },
        -- underline = { severity = vim.diagnostic.severity.ERROR },
        -- signs = {
        --   text = {
        --     [vim.diagnostic.severity.ERROR] = '󰅚 ',
        --     [vim.diagnostic.severity.WARN] = '󰀪 ',
        --     [vim.diagnostic.severity.INFO] = '󰋽 ',
        --     [vim.diagnostic.severity.HINT] = '󰌶 ',
        --   },
        -- },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- some are in core.init
      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--background-index', -- indexing for code navigation
            '--clang-tidy', -- linting
            '--cross-file-rename', -- rename across files
            '--compile-commands-dir=.', -- where compile_commands.json lives
            '--all-scopes-completion', -- better completion suggestions
            '--completion-style=detailed', -- include types in completion
            '--pch-storage=memory', -- faster precompiled headers
            '--header-insertion=never', -- optional: avoid auto-inserting headers
          },
          filetypes = { 'c', 'objc' },
          root_dir = require('lspconfig').util.root_pattern(
            'compile_commands.json',
            'Makefile',
            '.git'
          ),
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          settings = {
            clangd = {
              fallbackFlags = { '-std=c17' }, -- ensures standard if compile_commands.json missing
              diagnostics = { suppress = { 'unused-parameter' } },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers)
      vim.list_extend(ensure_installed, { 'stylua', 'lua_ls', 'rust_analyzer' })
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        -- ensure_installed = { 'clangd', 'lua_ls', 'rust_analyzer' },
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
            require('lspconfig')[server_name].setup(server)
            -- vim.lsp.config(server_name, server)
          end,
        },
      }
    end,
  },
}
