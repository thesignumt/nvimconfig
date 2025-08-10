return {
  'sigmacodeslol/cmtsep.nvim',
  callback = function()
    require('cmtsep').setup { preset = 'sigmacodeslol', key = ';;' }
  end,
}
