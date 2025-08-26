---@diagnostic disable: undefined-global
return {

  -- Module boilerplate
  s('mod', {
    t { 'local M = {}', '' },
    t { 'function M.' },
    i(1, 'name'),
    t '(',
    i(2, 'args'),
    t { ')', '  ' },
    i(0),
    t { '', 'end', '', 'return M' },
  }),
}
