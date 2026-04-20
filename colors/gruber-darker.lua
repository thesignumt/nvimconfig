local accents = {
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

local colors = {
    fg = '#e4e4ef',
    fg_light = '#f4f4ff',
    bg = '#101010',
    bg_alt = '#282828',
    white = '#ffffff',
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

---opts for hl
---@param fg_color string?
---@param bg_color string?
---@param opts table?
---@return table
local function hl_opts(fg_color, bg_color, opts)
    opts = opts or {}
    opts.fg = fg_color and fg_color
    opts.bg = bg_color and bg_color
    return opts
end

vim.o.background = 'dark'
vim.o.termguicolors = true
vim.cmd 'highlight clear'
if vim.fn.exists 'syntax_on' == 1 then
    vim.cmd 'syntax reset'
end
vim.g.colors_name = 'gruber-darker'

hl('Normal', hl_opts(colors.fg, colors.bg))

hl('@comment', hl_opts(colors.gray))

hl('@keyword', hl_opts(colors.yellow, nil, { bold = true }))
hl('@keyword.import', hl_opts(colors.quartz))
hl('@keyword.directive', hl_opts(colors.quartz))

hl('@string', hl_opts(colors.green))
hl('@string.escape', hl_opts(colors.green))

hl('@function', hl_opts(colors.fg))
hl('@function.call', hl_opts(colors.fg))

hl('@type', hl_opts(colors.fg))
hl('@type.builtin', hl_opts(colors.quartz))

hl('@variable', hl_opts(colors.fg_light))
hl('@property', hl_opts(colors.fg_light))

hl('Pmenu', hl_opts(colors.fg, colors.bg_alt))
hl('PmenuSel', hl_opts(colors.bg, accents.blue))
hl('PmenuSbar', hl_opts(nil, colors.bg_alt))
hl('PmenuThumb', hl_opts(nil, colors.quartz))

hl('CmpItemKindDefault', hl_opts(colors.fg))

hl('FloatBorder', hl_opts(colors.bg_alt))
hl('NormalFloat', hl_opts(nil, colors.bg_alt))

hl('StatusLine', hl_opts(colors.white, colors.bg_alt))
hl('StatusLineNC', hl_opts(colors.quartz, colors.bg_alt))

hl('DiagnosticError', hl_opts(accents.red))
hl('DiagnosticWarn', hl_opts(accents.yellow))
hl('DiagnosticInfo', hl_opts(accents.cyan))
hl('DiagnosticHint', hl_opts(accents.blue))

hl('Title', hl_opts(colors.yellow, nil, { bold = true }))

hl('GitSignsAdd', { fg = '#3f5a3f' })
hl('GitSignsChange', { fg = '#5a5a3f' })
hl('GitSignsDelete', { fg = '#5a3f3f' })
hl('GitSignsTopDelete', { fg = '#5a3f3f' })
hl('GitSignsChangeDelete', { fg = '#6a4a3a' })
