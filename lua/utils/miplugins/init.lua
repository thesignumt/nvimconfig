local fns = require('utils').fn -- functions
return {
  fns.miplugin('mkcmt', {
    opts = {},
    config = function(_, opts)
      require('mkcmt').setup(opts)
    end,
  }),
}
