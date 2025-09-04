return {
  'nvzone/showkeys',
  cmd = 'ShowkeysToggle',
  config = function()
    require('showkeys').setup {
      timeout = 1,
      position = 'top-right',
      winopts = {
        border = 'rounded',
      },
    }
  end,
}
