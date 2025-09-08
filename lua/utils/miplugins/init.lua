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

      ms('nV', m.dblL 'c', fn(mkcmt.comment, { after = true }))
      ms('nV', m.dblL 'C', fn(mkcmt.comment, { after = false }))
    end,
  }),
}
