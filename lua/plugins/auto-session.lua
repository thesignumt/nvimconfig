return {
  'rmagatti/auto-session',
  config = function()
    local status_ok, auto_session = pcall(require, 'auto-session')
    if not status_ok then
      vim.notify('Failed to load auto-session', vim.log.levels.ERROR)
      return
    end

    auto_session.setup {
      auto_restore = false, -- Updated option name for disabling auto-restore
      suppressed_dirs = {
        '~/',
        '~/Dev/',
        '~/Downloads',
        '~/Documents',
        '~/Desktop/',
      }, -- Updated option name
      auto_save = true, -- Explicitly enable auto-save for clarity
      auto_create = true, -- Ensure sessions are created if they don't exist
      log_level = 'error', -- Reduce verbosity
    }

    local nmap = require('utils.map').nmap

    nmap('<leader>er', '<cmd>SessionRestore<CR>', 'restore session for cwd')
    nmap('<leader>es', '<cmd>SessionSave<CR>', 'save session')
  end,
}
