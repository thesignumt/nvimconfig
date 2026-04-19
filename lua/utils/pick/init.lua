local M = {}

M.setup = function()
    local colors = {
        fg = '#e4e4ef',
        fg_plus1 = '#f4f4ff',
        white = '#ffffff',
        black = '#000000',
        bg_minus1 = '#101010',
        bg = '#181818',
        bg_plus1 = '#282828',
        bg_plus2 = '#453d41',
        bg_plus3 = '#484848',
        bg_plus4 = '#52494e',
        red_minus1 = '#c73c3f',
        red = '#f43841',
        red_plus1 = '#ff4f58',
        green = '#73c936',
        yellow = '#ffdd33',
        brown = '#cc8c3c',
        quartz = '#95a99f',
        niagara = '#96a6c8',
        niagara1 = '#565f73',
        niagara2 = '#303540',
        wisteria = '#9e95c7',
    }

    -- Basic editor highlights
    local highlights = {
        Normal = { fg = colors.fg, bg = colors.bg },
        Cursor = { fg = colors.black, bg = colors.yellow },
        Comment = { fg = colors.brown, italic = true },
        Constant = { fg = colors.quartz },
        Identifier = { fg = colors.niagara },
        Keyword = { fg = colors.yellow },
        Statement = { fg = colors.yellow, bold = true },
        PreProc = { fg = colors.quartz },
        Type = { fg = colors.quartz },
        Special = { fg = colors.green },
        Underlined = { fg = colors.niagara, underline = true },
        Error = { fg = colors.red_plus1 },
        Todo = { fg = colors.red_minus1, bold = true },
        LineNr = { fg = colors.bg_plus4, bg = colors.bg },
        CursorLineNr = { fg = colors.yellow, bg = colors.bg },
        Visual = { bg = colors.bg_plus3 },
        Search = { fg = colors.black, bg = colors.fg_plus1 },
        IncSearch = { fg = colors.black, bg = colors.red },
    }

    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end

    vim.o.background = 'dark'
    vim.g.colors_name = 'gruber_darker'
end

-- M.setup()

return {
    projects = require 'utils.pick.projects',
}
