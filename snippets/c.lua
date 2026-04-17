---@diagnostic disable: undefined-global

local function header_macro(_, _)
  local filename = vim.fn.expand '%:t' -- get current file name
  filename = filename:gsub('%.', '_') -- replace dots with underscores
  filename = filename:upper() .. '_'
  return sn(nil, t(filename))
end

return {
  s('header', {
    t '#ifndef ',
    d(1, header_macro, {}),
    t { '', '#define ' },
    d(2, header_macro, {}),
    t { '', '', '' },
    i(0),
    t { '', '', '#endif // ' },
    d(3, header_macro, {}),
  }),
  s('hello world', {
    t {
      '#include <stdio.h>',
      '',
      'int main(void) {',
      '\tprintf("Hello, World\\n");',
    },
    i(1),
    t {
      '',
      '\treturn 0;',
      '}',
    },
  }),
  s('hello world args', {
    t {
      '#include <stdio.h>',
      '',
      'int main(int argc, char **argv) {',
      '\tprintf("Hello, World\\n");',
    },
    i(1),
    t {
      '',
      '\treturn 0;',
      '}',
    },
  }),
  s('da', { -- dynamic array
    t { 'typedef struct {', '\t' },
    i(1, 'void'),
    t '* data;',
    t { '', '\tsize_t count;', '\tsize_t capacity;', '' },
    t '} ',
    i(2, 'foo'),
    t ';',
  }),
}
