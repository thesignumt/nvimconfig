-- +-------------------------------------------------------+
-- [                         core                          ]
-- +-------------------------------------------------------+
require 'core.opts'
require 'core.lazy'
require 'core.remaps'
require 'core.cmds'
require 'core.genor'
require 'core.snippets'
require 'core.typst'
require 'core.video'

-- vim.cmd.colorscheme 'gruber-darker'
-- vim.cmd.colorscheme 'tokyonight-night'

-- +-------------------------------------------------------+
-- [                      utils setup                      ]
-- +-------------------------------------------------------+
local nmap = require('utils.map').nmap
local inst = require('utils.f').inst_fn

require('utils.highlight').setup()

local c = require('utils.cursor').new()
nmap('<leader>1', inst(c, 'toggle')(), 'change cursor')

-- +-------------------------------------------------------+
-- [                          lsp                          ]
-- +-------------------------------------------------------+

vim.filetype.add { extension = { h = 'c' } }

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            completion = { callSnippet = 'Replace' },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                ignoreDir = {
                    '.git',
                    'dist',
                    'build',
                    '.cache',
                },
                library = {
                    vim.env.VIMRUNTIME,
                },
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config('rust_analyzer', {
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = true,
            diagnostics = { enable = true },
            completion = { postfix = { enable = true } },
        },
    },
})
