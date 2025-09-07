local snippets_dir = vim.fn.stdpath 'config' .. '\\snippets'
require('luasnip').setup { enable_autosnippets = true }
require('luasnip.loaders.from_lua').load {
  paths = snippets_dir,
}

--  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local ls = require 'luasnip'
local m = require 'utils.map'

m.imap('<C-K>', function()
  ls.expand()
end)
m.modes('is', '<C-L>', function()
  ls.jump(1)
end)
m.modes('is', '<C-H>', function()
  ls.jump(-1)
end)
