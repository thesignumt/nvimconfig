local miplugin = require('utils').miplugin
local m = require 'utils.map'
local ms = m.modes
local fn = require('utils.f').fn

return {
  miplugin('mkcmt', {
    opts = {},
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
}
