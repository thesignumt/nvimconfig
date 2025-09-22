---@diagnostic disable: missing-parameter

-- +-------------------------------------------------------+
-- [                        helpers                        ]
-- +-------------------------------------------------------+
local kc = vim.keycode
local m = require 'utils.map'
local imap = m.imap
local nmap = m.nmap
local vmap = m.vmap
local fn = require('utils.f').fn

-- +-------------------------------------------------------+
-- [                        keymaps                        ]
-- +-------------------------------------------------------+
-- TIP: Disable arrow keys in normal mode
nmap('<left>', '<cmd>echo "Use h to move!!"<CR>')
nmap('<right>', '<cmd>echo "Use l to move!!"<CR>')
nmap('<up>', '<cmd>echo "Use k to move!!"<CR>')
nmap('<down>', '<cmd>echo "Use j to move!!"<CR>')

-- See `:help wincmd` for a list of all window commands
nmap('<C-h>', '<C-w><C-h>', 'Move focus to the left window')
nmap('<C-l>', '<C-w><C-l>', 'Move focus to the right window')
nmap('<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
nmap('<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

-- m.modes('nv', '<leader>lc', ':CodeCompanionChat<cr>', 'CodeCompanionChat')

-- Flash plugin shortcuts
nmap('<leader>ls', require('flash').jump, 'Flash Jump')
nmap('<leader>lt', require('flash').treesitter, 'Flash Treesitter')
nmap(
  '<leader>lr',
  require('flash').treesitter_search,
  'Flash Treesitter Search'
)

-- +-------------------------------------------------------+
-- [                          IO                           ]
-- +-------------------------------------------------------+
nmap('<leader>q', ':q<cr>')
nmap('<leader>Q', ':qa!<cr>', 'quit neovim')
nmap('<leader>w', ':write<cr>')
nmap('<leader>o', ':update<cr>:source<cr>')
-- open RC files
nmap('<leader>v', ':e $MYVIMRC<cr>')
nmap('<leader>ew', ':e ~/.config/wezterm/wezterm.lua<cr>')
-- quickly switch files with alternate / switch it
nmap('<leader>x', ':e #<CR>')
nmap('<leader>X', ':bot sf #<CR>')

local ca = require 'cellular-automaton'
nmap('<leader>m', fn(ca.start_animation, 'make_it_rain'), 'make it rain')

-- +-------------------------------------------------------+
-- [               clipboard/register stuff                ]
-- +-------------------------------------------------------+
-- Yank & paste above/below lines
nmap('<C-A-k>', 'yyP', 'Yank and paste above')
vmap('<C-A-k>', 'yP', 'Yank and paste above')

nmap('<C-A-j>', 'yyp', 'Yank and paste below')
vmap('<C-A-j>', 'ygv<Esc>p', 'Yank and paste below')

-- Yank entire buffer
nmap('yA', '<cmd>%yank+<cr>', { desc = 'yank buffer to "+' })

nmap('<leader>Y', '"+Y')
m.modes('nx', '<leader>y', '"+y')
m.modes('nx', '<leader>p', '"+p')
m.modes('nx', '<leader>d', '"+d')
m.modes('nv', '<leader>c', '1z=')

-- Paste without overwriting register
m.xmap('p', '"_dP')

m.modes('nx', '-', '"_', 'void register') -- void register

-- +-------------------------------------------------------+
-- [                       movement                        ]
-- +-------------------------------------------------------+
-- Execute code
-- map({ 'n', 'v' }, '<leader>x', '<cmd>.lua<cr>', mt(opts, { desc = 'Execute line/selection' }))

-- Toggle tab width 2 <-> 4
nmap('<leader>tw', function()
  local new_width = (vim.bo.tabstop == 2) and 4 or 2
  vim.bo.tabstop = new_width
  vim.bo.shiftwidth = new_width
  vim.bo.softtabstop = new_width
  print('tab size ' .. new_width)
end, 'tab spaces 2 <-> 4')

-- Visual mode move lines up/down
vmap('J', ":m '>+1<cr>gv=gv")
vmap('K', ":m '<-2<cr>gv=gv")

-- Join lines without moving cursor
nmap('J', 'mzJ`z:delm z<cr>')
nmap('gJ', 'mzgJ`z:delm z<cr>')

-- Center screen after movement commands
nmap('<C-d>', '<C-d>zz')
nmap('<C-u>', '<C-u>zz')
nmap('G', 'Gzz')
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')

nmap('<leader>zig', '<cmd>LspRestart<cr>')
nmap('<leader>zl', ':Lazy<cr>')
-- ↓ just in case if i took to long to press <leader>zl all at once leading into lazy install/update/... remaps
nmap('<leader>zll', ':Lazy<cr>')
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

nmap('q;', 'q:')

-- Paste line above/below preserving cursor
-- nmap('<leader>p', 'm`o<ESC>p``', 'Paste line below')
-- nmap('<leader>P', 'm`O<ESC>p``', 'Paste line above')

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

nmap(
  '<leader>S',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  'search & replace'
)
-- Record Picker
-- nmap('<leader>R', ':RecordPicker<cr>')
