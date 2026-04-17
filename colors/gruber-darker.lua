-- TODO: isolate the C colors
local M = {
  enabled = true,
}

M.accents = {
  red = '#E85A4F',
  coral = '#FF6B6B',
  rose = '#FF758F',
  pink = '#E57AA4',
  lavender = '#C9A0FF',
  violet = '#A998F0',
  blue = '#5B82C7',
  cyan = '#64B8B4',
  mint = '#7CE0C2',
  green = '#5FB36A',
  lime = '#9ACD5A',
  yellow = '#F6CE4E',
  peach = '#FFB07C',
  orange = '#FF8E29',
}

M.colors = {
  fg = '#e4e4ef',
  fg_light = '#f4f4ff',
  bg = '#101010',
  bg_alt = '#282828',
  gray = '#cc8c3c',
  quartz = '#95a99f',
  yellow = '#ffdd33',
  green = '#73c936',
  red = '#f43841',
}

---set highlight
---@param name string
---@param val vim.api.keyset.highlight
local function hl(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

function M.apply()
  if not M.enabled then
    return
  end

  vim.o.background = 'dark'
  vim.g.colors_name = 'gruber-darker'

  vim.cmd.highlight 'clear'
  if vim.fn.has 'syntax_on' then
    vim.cmd.syntax 'reset'
  end

  hl('Normal', { bg = M.colors.bg, fg = M.colors.fg })

  hl('StatusLine', {
    fg = '#ffffff',
    bg = '#282828',
  })

  hl('StatusLineNC', {
    fg = '#95a99f',
    bg = '#282828',
  })

  hl('Comment', { fg = '#cc8c3c' })
  hl('Keyword', { fg = '#ffdd33', bold = true })
  hl('Statement', { fg = '#ffdd33', bold = true })

  hl('String', { fg = '#73c936' })
  hl('Function', { fg = M.colors.fg })
  hl('Type', { fg = '#95a99f' })
  hl('Identifier', { fg = '#f4f4ff' })

  -- preprocessor
  hl('PreProc', { fg = '#95a99f' })
  hl('@preproc', { fg = '#95a99f' })
  hl('@include', { fg = '#95a99f' })

  hl('cFormat', { link = 'String' })
  hl('cCharacter', { link = 'String' })
  hl('cSpecial', { link = 'String' })

  hl('DiagnosticError', { fg = M.accents.red })
  hl('DiagnosticWarn', { fg = M.accents.yellow })
  hl('DiagnosticInfo', { fg = M.accents.cyan })
  hl('DiagnosticHint', { fg = M.accents.blue })

  hl('GitSignsAdd', { fg = '#3f5a3f' })
  hl('GitSignsChange', { fg = '#5a5a3f' })
  hl('GitSignsDelete', { fg = '#5a3f3f' })
  hl('GitSignsTopDelete', { fg = '#5a3f3f' })
  hl('GitSignsChangeDelete', { fg = '#6a4a3a' })

  vim.g.terminal_color_0 = M.colors.dark_gray
  vim.g.terminal_color_1 = M.accents.red
  vim.g.terminal_color_2 = M.accents.green
  vim.g.terminal_color_3 = M.accents.yellow
  vim.g.terminal_color_4 = M.accents.blue
  vim.g.terminal_color_5 = M.accents.pink
  vim.g.terminal_color_6 = M.accents.cyan
  vim.g.terminal_color_7 = M.colors.white
end

function M.setup(opts)
  opts = opts or {}

  if opts.colors then
    M.colors = vim.tbl_extend('force', M.colors, opts.colors)
  end

  if opts.enabled ~= nil then
    M.enabled = opts.enabled
  end

  if opts.startup then
    M.apply()
  end
end

function M.toggle()
  M.enabled = not M.enabled
  if M.enabled then
    M.apply()
  end
end

M.apply()

return M
