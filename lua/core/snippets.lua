require('luasnip').setup {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  ext_opts = {
    [require('luasnip.util.types').choiceNode] = {
      active = { virt_text = { { '<-', 'Error' } } },
    },
  },
}

local snippets_dir = vim.fn.stdpath 'config' .. '\\snippets'
require('luasnip.loaders.from_lua').load {
  paths = snippets_dir,
}

-- +-------------------------------------------------------+
-- [                        keymaps                        ]
-- +-------------------------------------------------------+

local ls = require 'luasnip'
local m = require 'utils.map'
local fn = require('utils.f').fn

m.imap('<C-K>', ls.expand)
m.modes('is', '<C-L>', fn(ls.jump, 1))
m.modes('is', '<C-H>', fn(ls.jump, -1))
