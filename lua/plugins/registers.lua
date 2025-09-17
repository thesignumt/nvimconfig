return {
  'tversteeg/registers.nvim',
  cmd = 'Registers',
  config = true,
  keys = {
    { '"', mode = { 'n', 'v' } },
    { '<C-R>', mode = 'i' },
  },
  name = 'registers',
  init = function()
    ---@diagnostic disable-next-line: missing-fields
    require('registers').setup {}
  end,
}
