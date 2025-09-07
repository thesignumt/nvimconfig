---@diagnostic disable: missing-parameter

------------------------------------------------------------
-- Helpers
------------------------------------------------------------

local kc = vim.keycode
local m = require 'utils.map'
local imap = m.imap
local nmap = m.nmap
local vmap = m.vmap

-- DIY comment toggle
function _G.toggle_comment()
  local line = vim.api.nvim_get_current_line()
  local comment_string = vim.bo.commentstring:match '^(.*)%%s' or '//'

  if line:match('^%s*' .. vim.pesc(comment_string)) then
    line = line:gsub('^%s*' .. vim.pesc(comment_string) .. '%s?', '')
  else
    line = comment_string .. ' ' .. line
  end

  vim.api.nvim_set_current_line(line)
end

-- Filetype-aware increment snippet
-- local function plusplus()
--   if vim.bo.filetype == 'python' then
--     return ' += 1'
--   elseif vim.bo.filetype == 'c' then
--     return '++;'
--   else
--     return ' = <Esc>^yt=f=lpa+ 1'
--   end
-- end

------------------------------------------------------------
-- Plugin Keymaps
------------------------------------------------------------

-- CodeCompanion
m.modes('nv', '<leader>lc', ':CodeCompanionChat<cr>', 'CodeCompanionChat')

-- Barbar Buffer Navigation
-- map('n', '<A-,>', '<Cmd>BufferPrevious<cr>', opts)
-- map('n', '<A-.>', '<Cmd>BufferNext<cr>', opts)
-- map('n', '<A-<>', '<Cmd>BufferMovePrevious<cr>', opts)
-- map('n', '<A->>', '<Cmd>BufferMoveNext<cr>', opts)
-- map('n', '<A-p>', '<Cmd>BufferPin<cr>', opts)
-- map('n', '<A-c>', '<Cmd>BufferClose<cr>', opts)

-- Flash plugin shortcuts
nmap('<leader>ls', require('flash').jump, 'Flash Jump')
nmap('<leader>lt', require('flash').treesitter, 'Flash Treesitter')
nmap(
  '<leader>lr',
  require('flash').treesitter_search,
  'Flash Treesitter Search'
)

------------------------------------------------------------
-- File and Config Management
------------------------------------------------------------

nmap('<leader>v', ':e $MYVIMRC<cr>')
nmap('<leader>q', ':q<cr>')
nmap('<leader>Q', ':qa!<cr>', 'quit neovim')
nmap('<leader>w', ':write<cr>')
nmap('<leader>o', ':update<cr>:source<cr>')

-- Uncomment if you want explorer keymap
-- map('n', '<leader>we', ':!explorer .<cr><cr>', mt(opts, { desc = 'open file explorer' }))

------------------------------------------------------------
-- Editing & Movement
------------------------------------------------------------

-- Execute code
-- map({ 'n', 'v' }, '<leader>x', '<cmd>.lua<cr>', mt(opts, { desc = 'Execute line/selection' }))

-- Toggle tab width 2 <-> 4
nmap('<leader>tw', function()
  local new_width = (vim.bo.tabstop == 2) and 4 or 2
  vim.bo.tabstop = new_width
  vim.bo.shiftwidth = new_width
  vim.bo.softtabstop = new_width
end, 'tab spaces 2 <-> 4')

-- Yank & paste above/below lines
m.modes('n', '<C-A-k>', 'yyP', 'Yank and paste above')
m.modes('v', '<C-A-k>', 'yP', 'Yank and paste above')

m.modes('n', '<C-A-j>', 'yyp', 'Yank and paste below')
m.modes('v', '<C-A-j>', 'ygv<Esc>p', 'Yank and paste below')

-- New line without yanking
-- map('n', '<A-o>', 'mzo<Esc>0"_D`z:delm z<cr>', opts)
-- map('n', '<A-O>', 'mzO<Esc>0"_D`z:delm z<cr>', opts)

-- Yank entire buffer
nmap('yA', '<cmd>%yank+<cr>', { desc = 'yank buffer to "+' })

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

-- Clipboard yank
nmap('<leader>Y', '"+Y')
m.modes('nx', '<leader>y', '"+y')
m.modes('nx', '<leader>p', '"+p')
m.modes('nx', '<leader>d', '"+d')
m.modes('nv', '<leader>c', '1z=')

-- Search & replace word under cursor
-- nmap(
--   '<leader>s',
--   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
--   'replace word'
-- )

-- Paste without overwriting register
m.xmap('p', '"_dP')

-- Delete all marks
m.modes('nv', 'dm', ':delm!<cr>', 'Delete all marks')

-- Line navigation (start and end of line)
m.modes('nv', 'H', '^', 'Start of line')
m.modes('nv', 'L', 'g_', 'End of line')

-- Indent and keep selection
vmap('<', '<gv')
vmap('>', '>gv')

-- Divide code chunk with comment toggle
-- map(
--   'n',
--   ';;',
--   'O<Esc>33i- <Esc>:lua toggle_comment()<cr>',
--   mt(opts, { desc = 'Divide code chunk' })
-- )

-- Toggle diagnostics on/off
-- map('n', '<leader>td', function()
--   vim.diagnostic.enable(not vim.diagnostic.is_enabled())
-- end, { silent = true, noremap = true, desc = 'Toggle diagnostics' })

-- Paste line above/below preserving cursor
-- nmap('<leader>p', 'm`o<ESC>p``', 'Paste line below')
-- nmap('<leader>P', 'm`O<ESC>p``', 'Paste line above')

------------------------------------------------------------
-- Insert mode mappings
------------------------------------------------------------

-- Undo/redo breakpoints
imap('<C-u>', '<C-g>u')
imap('<C-r>', '<C-g>U')

-- Break undo at punctuation
for _, ch in ipairs { ',', '.', '!', '?', ';', ':' } do
  imap(ch, ch .. '<c-g>u')
end

------------------------------------------------------------
-- Miscellaneous
------------------------------------------------------------

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

-- Record Picker
-- nmap('<leader>R', ':RecordPicker<cr>')
