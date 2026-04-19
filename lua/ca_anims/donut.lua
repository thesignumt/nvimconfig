local M = {}

local A = 0
local B = 0

local chars = { '.', ',', '-', '~', ':', ';', '=', '!', '*', '#', '$', '@' }

local function render(width, height)
    local z = {}
    local b = {}

    for i = 1, width * height do
        z[i] = 0
        b[i] = ' '
    end

    local j = 0
    while j < 6.28 do
        local i = 0
        while i < 6.28 do
            local c = math.sin(i)
            local d = math.cos(j)
            local e = math.sin(A)
            local f = math.sin(j)
            local g = math.cos(A)
            local h = d + 2
            local D = 1 / (c * h * e + f * g + 5)
            local l = math.cos(i)
            local m = math.cos(B)
            local n = math.sin(B)
            local t = c * h * g - f * e

            local x = math.floor(width / 2 + (width / 3) * D * (l * h * m - t * n))
            local y = math.floor(height / 2 + (height / 2) * D * (l * h * n + t * m))
            local o = x + width * y

            local N = math.floor(8 * ((f * e - c * d * g) * m - c * d * e - f * g - l * d * n))

            if y > 0 and y < height and x > 0 and x < width then
                if D > (z[o] or 0) then
                    z[o] = D
                    local idx = (N > 0 and N or 0) + 1
                    b[o] = chars[idx] or '.'
                end
            end

            i = i + 0.02
        end
        j = j + 0.07
    end

    local lines = {}
    for y = 0, height - 1 do
        local row = {}
        for x = 0, width - 1 do
            row[#row + 1] = b[x + width * y] or ' '
        end
        lines[#lines + 1] = table.concat(row)
    end

    return lines
end

M = {
    fps = 30,
    name = 'donut',
    update = function(state, grid)
        local buf = vim.api.nvim_get_current_buf()
        local width = vim.api.nvim_win_get_width(0)
        local height = vim.api.nvim_win_get_height(0) - 1

        local frame = render(width, height)

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, frame)

        A = A + 0.04
        B = B + 0.02

        return true
    end,
}

return M
