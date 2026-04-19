---@diagnostic disable: missing-parameter

-- +-------------------------------------------------------+
-- [                        helpers                        ]
-- +-------------------------------------------------------+

local kc = vim.keycode
local m = require 'utils.map'
local imap = m.imap
local nmap = m.nmap
local vmap = m.vmap
local unmap = m.unmap
local dblL = m.dblL

-- +-------------------------------------------------------+
-- [                        keymaps                        ]
-- +-------------------------------------------------------+

nmap('<left>', '<NOP>')
nmap('<right>', '<NOP>')
nmap('<up>', '<NOP>')
nmap('<down>', '<NOP>')
-- nmap('<left>', '<cmd>echo "Use h to move!!"<CR>')
-- nmap('<right>', '<cmd>echo "Use l to move!!"<CR>')
-- nmap('<up>', '<cmd>echo "Use k to move!!"<CR>')
-- nmap('<down>', '<cmd>echo "Use j to move!!"<CR>')

-- See `:help wincmd` for a list of all window commands
nmap('<C-h>', '<C-w><C-h>', 'focus left window')
nmap('<C-l>', '<C-w><C-l>', 'focus right window')
nmap('<C-j>', '<C-w><C-j>', 'focus lower window')
nmap('<C-k>', '<C-w><C-k>', 'focus upper window')

nmap('<C-Up>', ':resize -2<CR>')
nmap('<C-Down>', ':resize +2<CR>')
nmap('<C-Left>', ':vertical resize -2<CR>')
nmap('<C-Right>', ':vertical resize +2<CR>')

-- m.modes('nx', '<leader>j', ':CodeCompanionChat<cr>', 'CodeCompanionChat')

-- +-------------------------------------------------------+
-- [                          IO                           ]
-- +-------------------------------------------------------+

nmap('<leader>q', ':q<cr>')
nmap('<leader>Q', ':q!<cr>', 'force quit')
nmap('<leader>w', ':w<cr>')
nmap('<C-w><C-w>', ':noautocmd w<cr>', 'write w/o fmt')
nmap('<leader>W', ':wa<cr>')
nmap('<leader>oi', ':tabedit .gitignore<cr>', 'edit .gitignore as tab')
-- quickly switch files with alternate / switch it
nmap('<leader>x', ':e #<CR>')
nmap('<leader>X', ':bot sf #<CR>')

nmap(dblL 'n', require('no-neck-pain').toggle, 'no neck pain XD')

-- +-------------------------------------------------------+
-- [               clipboard/register stuff                ]
-- +-------------------------------------------------------+

nmap('<leader>.', 'yyp', 'dupe below')
vmap('<leader>.', 'ygv<Esc>p', 'dupe below')

-- Yank buffer
nmap('yA', '<cmd>%yank+<cr>', 'yank buffer to "+')

nmap('<leader>Y', '"+Y')
m.modes('nx', '<leader>y', '"+y')
m.modes('nx', '<leader>p', '"+p')
-- m.modes('nx', '<leader>d', '"+d')
m.modes('nx', '<leader>n', ':norm ')
-- m.modes('nv', '<leader>c', '1z=')

m.xmap('p', '"_dP') -- paste w/o overriding reg

nmap('x', '"_x')

-- m.modes('nx', '-', '"_', 'void register') -- void register

-- +-------------------------------------------------------+
-- [                       movement                        ]
-- +-------------------------------------------------------+

-- Execute code
-- map({ 'n', 'v' }, '<leader>x', '<cmd>.lua<cr>', mt(opts, { desc = 'Execute line/selection' }))

-- Toggle tab width 2 <-> 4
nmap('<leader>ts', function()
    local new_width = (vim.bo.tabstop == 2) and 4 or 2
    vim.bo.tabstop = new_width
    vim.bo.shiftwidth = new_width
    vim.bo.softtabstop = new_width
    print('tab size ' .. new_width)
end, 'tab spaces 2 <-> 4')

-- Visual mode move lines up/down
vmap('J', ":m '>+1<cr>gv=gv")
vmap('K', ":m '<-2<cr>gv=gv")

-- join lines
nmap('J', 'gJ', 'join lines')
nmap('gK', "@='ddkPJ'<cr>|", 'join line reversed')

-- Center screen after movement commands
nmap('<C-d>', '<C-d>zz')
nmap('<C-u>', '<C-u>zz')
nmap('G', 'Gzz')
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')

nmap('<leader>zig', '<cmd>LspRestart<cr>')
nmap('<leader>zl', ':Lazy<cr>')
nmap('<leader>zli', ':Lazy install<cr>')
nmap('<leader>zlu', ':Lazy update<cr>')

-- Delete all marks
m.modes('nv', 'dm', ':delm!<cr>', 'Delete all marks')

-- Line navigation (start and end of line)
m.modes('nv', 'H', '^', 'Start of line')
m.modes('nv', 'L', 'g_', 'End of line')

-- Indent and keep selection
vmap('<', '<gv')
vmap('>', '>gv')

-- nmap('q;', 'q:')

-- +-------------------------------------------------------+
-- [                      breakpoints                      ]
-- +-------------------------------------------------------+

-- Undo/redo breakpoints
imap('<C-u>', '<C-g>u')
imap('<C-r>', '<C-g>U')

-- Break undo at punctuation
for _, ch in ipairs { ',', '.', '!', '?', ';', ':' } do
    imap(ch, ch .. '<c-g>u')
end

-- +-------------------------------------------------------+
-- [                         other                         ]
-- +-------------------------------------------------------+

local situtils = require 'core.situtils'
nmap(dblL 'q', situtils.pick, 'handy utils')
nmap(dblL 'w', situtils.fetch_raw_url, 'wget')
nmap(dblL 'g', situtils.open_git_origin, 'open git origin')

-- manpage
nmap('<leader>im', function()
    local topic = vim.fn.input 'Man topic (<cword>): '
    topic = topic ~= '' and topic or vim.fn.expand '<cword>'
    vim.cmd.Man(vim.fn.escape(topic, ' '))
end, 'open manpage sec 3')

m.modes('ni', '<C-z>', function()
    local api = vim.api
    local fn = vim.fn

    local cs = vim.bo.commentstring
    if not cs or cs == '' or not cs:find '%%s' then
        return
    end

    local next_key = fn.getcharstr()

    -- extract comment prefix (trimmed)
    local prefix = cs:gsub('%%s', ''):match '^%s*(.-)%s*$'
    if not prefix or prefix == '' then
        return
    end

    local row, col = unpack(api.nvim_win_get_cursor(0))
    row = row - 1

    local min_len, max_len = 30, 40
    local fixed_len = 30 -- fixed length for <C-z>/<C-x>
    local repeat_len = 30 -- fixed repeat for printable ASCII

    local fill_char
    local fill_len

    if next_key == kc '<Esc>' then
        return

    -- ctrl-z / ctrl-x fixed length
    elseif next_key == kc '<C-z>' or next_key == kc '<C-x>' then
        fill_char = prefix:sub(1, 1)
        cs = cs:gsub(' ', '', 1)
        fill_len = fixed_len - 2

    -- printable ASCII: fixed repeat_len
    elseif next_key:match '^[ -~]$' then
        fill_char = next_key
        fill_len = repeat_len
    else
        return
    end

    local text = string.rep(fill_char, fill_len)
    local formatted = cs:format(text)

    -- clamp to max_len just in case
    if #formatted > max_len then
        formatted = formatted:sub(1, max_len)
    end

    api.nvim_buf_set_text(0, row, col, row, col, { formatted })
end, 'cmt line')

-- Toggle hlsearch on Enter keypress
nmap('<cr>', function()
    vim.cmd [[ echon '' ]]
    if vim.v.hlsearch == 1 then
        vim.cmd.nohl()
        return ''
    else
        return kc '<cr>'
    end
end, { expr = true })

nmap('<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'search & replace')
-- Record Picker
-- nmap('<leader>R', ':RecordPicker<cr>')

nmap('<leader>in', ':Inspect<cr>', 'inspect hl')

unmap('n', '<leader>td')
unmap('n', '<leader>tD')
