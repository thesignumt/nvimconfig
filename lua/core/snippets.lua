local snippets_dir = vim.fn.stdpath 'config' .. '\\snippets'
require('luasnip').setup { enable_autosnippets = true }
require('luasnip.loaders.from_lua').load {
  paths = snippets_dir,
}

--  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local ls = require 'luasnip'
local m = require 'utils.map'
local fn = require('utils.f').fn

m.imap('<C-K>', ls.expand)
m.modes('is', '<C-L>', fn(ls.jump, 1))
m.modes('is', '<C-H>', fn(ls.jump, -1))
