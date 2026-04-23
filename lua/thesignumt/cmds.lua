vim.api.nvim_create_user_command('ListPlugins', function()
    local home = vim.uv.os_homedir()
    local filepath = home .. '\\lazy_plugins.txt' -- Windows path

    local f = io.open(filepath, 'w')
    if f then
        for _, p in pairs(require('lazy').plugins()) do
            f:write(p.name .. '\n')
        end
        f:close()
        print('Plugin list written to: ' .. filepath)
    else
        print 'Error: could not write file'
    end
end, {})

local function free_remaps(prefix)
    local api = vim.api
    local modes = { 'n', 'v', 'x', 'o', 'i', 'c' }

    -- US keyboard keys (letters, numbers, symbols)
    local keys = {}
    for _, k in ipairs {
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '!',
        '@',
        '#',
        '$',
        '%',
        '^',
        '&',
        '*',
        '(',
        ')',
        '-',
        '=',
        '[',
        ']',
        '\\',
        ';',
        "'",
        ',',
        '.',
        '/',
        '`',
        '~',
    } do
        keys[k] = true
    end

    -- normalize prefix
    prefix = api.nvim_replace_termcodes(prefix, true, false, true)

    -- remove keys already mapped under the prefix
    for _, mode in ipairs(modes) do
        for _, map in ipairs(api.nvim_get_keymap(mode)) do
            local lhs = api.nvim_replace_termcodes(map.lhs, true, false, true)
            if lhs:sub(1, #prefix) == prefix then
                local rest = lhs:sub(#prefix + 1, #prefix + 1)
                keys[rest] = nil
            end
        end
    end

    -- collect and sort free keys
    local free = vim.tbl_keys(keys)
    table.sort(free)

    if #free == 0 then
        print('No free keys under ' .. prefix)
    else
        print('Free keys under ' .. prefix .. ': ' .. table.concat(free, ' '))
    end
end

-- Create user command
vim.api.nvim_create_user_command('FreeRemaps', function(opts)
    local arg = opts.args ~= '' and opts.args or '<leader>'
    free_remaps(arg)
end, { nargs = '?' })

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'man',
--   callback = function()
--     vim.cmd 'wincmd J'
--   end,
-- })

-- vim.api.nvim_create_user_command('ClrShada', function()
--   local job_id =
--     vim.fn.jobstart 'powershell -c "Get-ChildItem ~\\AppData\\Local\\nvim-data\\shada | Where-Object {$_.Name -like \'*.tmp*\' } | Remove-Item -Recurse -Force"'
-- end, {})
