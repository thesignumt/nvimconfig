---@diagnostic disable: undefined-global
return {

  -- Module boilerplate
  s('mod', {
    t 'local M = {}',
    t { '', '', '' }, -- newlines
    i(0), -- cursor position
    t { '', '', 'return M' },
  }),
  s('dblL', {
    t { '<leader><leader>' },
  }),
}
