-- +-------------------------------------------------------+
-- [                  ENSURE LAZY INSTALL                  ]
-- +-------------------------------------------------------+
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- +-------------------------------------------------------+
-- [                        helpers                        ]
-- +-------------------------------------------------------+
local nmap = require('utils.map').nmap
local fn = require('utils.f').fn

-- +-------------------------------------------------------+
-- [                     LAZY PLUGINS                      ]
-- +-------------------------------------------------------+
require('lazy').setup({
  { import = 'plugins' },
  { import = 'utils.miplugins' },

  { -- Git signs
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Which-key for keybind hints
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>e', group = 'env' },
        { '<leader>s', group = 'sondear' },
        { '<leader>t', group = 'toggleterm' },
        { '<leader>l', group = 'LSP' },
      },
    },
  },

  { -- Telescope fuzzy finder
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
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
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = require('telescope.themes').get_dropdown(),
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      nmap('<leader>sh', builtin.help_tags, 'help')
      nmap('<leader>sk', builtin.keymaps, 'keymaps')
      nmap('<leader>sf', builtin.find_files, 'files')
      nmap('<leader>ss', builtin.builtin, 'search telescope')
      nmap('<leader>sw', builtin.grep_string, 'word')
      nmap('<leader>sg', builtin.live_grep, 'grep')
      nmap('<leader>sd', builtin.diagnostics, 'diagnostics')
      nmap('<leader>sr', builtin.resume, 'resume')
      nmap('<leader>s.', builtin.oldfiles, 'recent')
      nmap('<leader>sb', builtin.buffers, 'buffers')

      nmap(
        '<leader>/',
        fn(
          builtin.current_buffer_fuzzy_find,
          require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          }
        ),
        'fzf in buffer'
      )

      nmap(
        '<leader>s/',
        fn(
          builtin.live_grep,
          { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
        ),
        'grep in open files'
      )
      nmap(
        '<leader>sn',
        fn(builtin.find_files, { cwd = vim.fn.stdpath 'config' }),
        'nvim conf files'
      )
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
    },
  },

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
          map(
            '<leader>ed',
            require('telescope.builtin').lsp_document_symbols,
            'document symbols'
          )
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
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        window = {
          completion = {
            border = vim.g.cmp_winborder,
            winhighlight = 'FloatBorder:CmpBorder',
          },
          documentation = {
            border = vim.g.cmp_winborder,
            winhighlight = 'FloatBorder:CmpDocBorder',
          },
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping.confirm { select = true },

          -- ['<CR>'] = cmp.mapping.confirm { select = true },
          -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          -- ['<C-Space>'] = cmp.mapping.complete {},
          -- ['<C-l>'] = function() if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end end,
          -- ['<C-h>'] = function() if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end end,
        },
        sources = {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },
      }
    end,
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup { styles = { comments = { italic = false } } }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }
      require('mini.icons').setup()
      require('mini.pick').setup()
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'python',
        'bash',
        'c',
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
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
