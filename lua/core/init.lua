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

-- +-------------------------------------------------------+
-- [                      utils setup                      ]
-- +-------------------------------------------------------+
local nmap = require('utils.map').nmap
local inst = require('utils.f').inst_fn

require('utils.highlight').setup()

local pick = require 'utils.pick'
nmap('<leader>sc', pick.colorscheme, 'colorscheme')

local c = require('utils.cursor').new()
nmap('<F2>', inst(c, 'toggle')())

-- +-------------------------------------------------------+
-- [                          lsp                          ]
-- +-------------------------------------------------------+
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      completion = { callSnippet = 'Replace' },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})
