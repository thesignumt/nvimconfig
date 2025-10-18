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

-- expand snippet
m.imap('<C-k>', function()
  if ls.expandable() then
    ls.expand()
  end
end)

-- jump forward
m.modes('is', '<C-l>', function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end)

m.modes('is', '<C-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)
