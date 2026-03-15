---@module "compile-mode"
---@type CompileModeOpts
vim.g.compile_mode = {
  default_command = '',
  bang_expansion = true,
  baleia_setup = true,
  auto_scroll = true,
  use_diagnostics = true,
  focus_compilation_buffer = false,
  ask_about_save = true,
}

return {
  'ej-shafran/compile-mode.nvim',
  version = '^5.0.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'm00qek/baleia.nvim', tag = 'v1.4.0' },
  },
  config = function()
    local nmap = require('utils.map').nmap
    nmap('<leader><leader>e', '<cmd>Compile<cr>', 'compile mode')
    nmap('<leader><leader>3', '<cmd>Recompile<cr>', 'recompile')
  end,
}
