local miplugin = require('utils').miplugin
local m = require 'utils.map'
local ms = m.modes
local nmap = m.nmap
local fn = require('utils.f').fn

return {
  miplugin('mkcmt', {
    ---@type MkcmtConfig
    opts = { default_header = 'I USE NEOVIM BTW!!! :3' },
    config = function(_, opts)
      local mkcmt = require 'mkcmt'
      mkcmt.setup(opts)

      local c = { after = true, upper = false }
      local C = { after = false, upper = false }
      local x = { after = true, upper = true }
      local X = { after = false, upper = true }

      ms('nv', m.dblL 'c', fn(mkcmt.comment, c), 'mkcmt after')
      ms('nv', m.dblL 'C', fn(mkcmt.comment, C), 'mkcmt before')
      ms('nv', m.dblL 'x', fn(mkcmt.comment, x), 'MKCMT after')
      ms('nv', m.dblL 'X', fn(mkcmt.comment, X), 'MKCMT before')
    end,
  }),
  miplugin('def', {
    opts = {},
    config = function(_, opts)
      local def = require 'def'
      def.setup(opts)

      nmap('<leader>iw', fn(def.lookup, 'word'), 'word def')
      nmap('<leader>is', fn(def.lookup, 'lookup'), 'search word def')
      nmap('<leader>if', fn(def.lookup, 'favorites'), 'search fav word def')
    end,
  }),
}
