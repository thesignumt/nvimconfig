return {
  'sigmacodeslol/cmtsep.nvim',
  callback = function()
    local cmtsep = require 'cmtsep'
    cmtsep.setup { preset = 'sigmacodeslol' }
    vim.keymap.set('n', ';;', cmtsep.insert_comment_block, {
      noremap = true,
      silent = true,
      desc = 'Insert beautified comment block separator',
    })
  end,
}
