---@diagnostic disable: missing-parameter

------------------------------------------------------------
-- Helpers
------------------------------------------------------------

local map = vim.keymap.set
local kc = vim.keycode
local opts = { noremap = true, silent = true }

-- Delete keymaps utility
local function unmap(modes, lhs)
  modes = type(modes) == 'string' and { modes } or modes
  lhs = type(lhs) == 'string' and { lhs } or lhs
  for _, mode in pairs(modes) do
    for _, l in pairs(lhs) do
      pcall(vim.keymap.del, mode, l)
    end
  end
end

-- Merge tables (t2 overwrites t1 on conflict)
local function mt(t1, t2)
  local out = {}
  for k, v in pairs(t1) do
    out[k] = v
  end
  for k, v in pairs(t2) do
    out[k] = v
  end
  return out
end

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
local function plusplus()
  if vim.bo.filetype == 'python' then
    return ' += 1'
  elseif vim.bo.filetype == 'c' then
    return '++;'
  else
    return ' = <Esc>^yt=f=lpa+ 1'
  end
end

------------------------------------------------------------
-- Plugin Keymaps
------------------------------------------------------------

-- CodeCompanion
map(
  { 'n', 'v' },
  '<leader>cp',
  ':CodeCompanionChat<cr>',
  mt(opts, { desc = 'CodeCompanionChat' })
)

-- Oil
map('n', '-', ':Oil<cr>', opts)

-- Barbar Buffer Navigation
map('n', '<A-,>', '<Cmd>BufferPrevious<cr>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<cr>', opts)
map('n', '<A-<>', '<Cmd>BufferMovePrevious<cr>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<cr>', opts)
map('n', '<A-p>', '<Cmd>BufferPin<cr>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<cr>', opts)

-- Flash plugin shortcuts
map('n', '<leader>ls', function()
  require('flash').jump()
end, mt(opts, { desc = 'Flash Jump' }))
map('n', '<leader>lt', function()
  require('flash').treesitter()
end, mt(opts, { desc = 'Flash Treesitter' }))
map('n', '<leader>lr', function()
  require('flash').treesitter_search()
end, mt(opts, { desc = 'Flash Treesitter Search' }))

-- Screenkey
map(
  'n',
  '<leader>kt',
  ':Screenkey toggle<cr>',
  mt(opts, { desc = 'toggle Screenkey' })
)
map(
  'n',
  '<leader>kr',
  ':Screenkey redraw<cr>',
  mt(opts, { desc = 'redraw Screenkey' })
)

-- ZenMode
map('n', '<leader>u', ':ZenMode<cr>', opts)

------------------------------------------------------------
-- File and Config Management
------------------------------------------------------------

map(
  'n',
  '<leader>vpp',
  '<cmd>e ' .. vim.fn.stdpath 'config' .. '/init.lua<cr>',
  mt(opts, { desc = 'Jump to configuration file' })
)
map('n', '<leader>q', ':x<cr>', opts)
map('n', '<leader>Q', ':qa!<cr>', { desc = 'quit neovim' })
map('n', '<leader>w', ':write<cr>', opts)
map('n', '<leader>o', ':update<CR> :source<CR>')

map(
  'n',
  '<leader>cd',
  '<cmd>lcd %:p:h<cr><cmd>pwd<cr>',
  { desc = 'change cwd' }
)

-- Uncomment if you want explorer keymap
-- map('n', '<leader>we', ':!explorer .<cr><cr>', mt(opts, { desc = 'open file explorer' }))

------------------------------------------------------------
-- Editing & Movement
------------------------------------------------------------

-- Execute code
-- map({ 'n', 'v' }, '<leader>x', '<cmd>.lua<cr>', mt(opts, { desc = 'Execute line/selection' }))

-- Toggle tab width 2 <-> 4
map('n', '<leader>tw', function()
  local new_width = (vim.bo.tabstop == 2) and 4 or 2
  vim.bo.tabstop = new_width
  vim.bo.shiftwidth = new_width
  vim.bo.softtabstop = new_width
end, mt(opts, { desc = 'tab spaces 2 <-> 4' }))

-- Yank & paste above/below lines
map({ 'n', 'v' }, '<C-A-k>', function()
  return vim.fn.mode() == 'n' and 'yyP' or 'yP'
end, { expr = true, desc = 'Yank and paste above' })
map({ 'n', 'v' }, '<C-A-j>', function()
  return vim.fn.mode() == 'n' and 'yyp' or 'ygv<Esc>p'
end, { expr = true, desc = 'Yank and paste below' })

-- New line without yanking
map('n', '<A-o>', 'o<Esc>0"_D', opts)
map('n', '<A-O>', 'O<Esc>0"_D', opts)

-- Select all / Replace all
map('n', '==', 'ggVG', mt(opts, { desc = 'Select entire buffer' }))
map(
  'n',
  '=p',
  'ggVGp',
  mt(opts, { desc = 'Replace entire buffer with clipboard' })
)

-- Yank entire buffer
map('n', 'yA', '<cmd>%yank<cr>', { desc = 'Yank entire buffer' })

-- Visual mode move lines up/down
map('v', 'J', ":m '>+1<cr>gv=gv", opts)
map('v', 'K', ":m '<-2<cr>gv=gv", opts)

-- Join lines without moving cursor
map('n', 'J', function()
  vim.cmd [[ normal! mzJ`z | delmarks z ]]
end, { desc = 'Join lines without moving cursor' })
map('n', 'gJ', function()
  vim.cmd [[ normal! mzgJ`z | delmarks z ]]
end, { desc = 'Join lines without moving cursor' })

-- Center screen after movement commands
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', 'G', 'Gzz', opts)
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- Clipboard yank
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map('n', '<leader>Y', '"+Y', opts)

-- Search & replace word under cursor
map(
  'n',
  '<leader>s',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  opts
)

-- Paste without overwriting register
map('v', 'p', '"_dP', opts)

-- Delete all marks
map({ 'n', 'v' }, 'dm', 'delm!<cr>kj', mt(opts, { desc = 'Delete all marks' }))

-- Line navigation (start and end of line)
map({ 'n', 'v' }, 'H', '^', mt(opts, { desc = 'Start of line' }))
map({ 'n', 'v' }, 'L', 'g_', mt(opts, { desc = 'End of line' }))

-- Indent and keep selection
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Divide code chunk with comment toggle
-- map(
--   'n',
--   ';;',
--   'O<Esc>33i- <Esc>:lua toggle_comment()<cr>',
--   mt(opts, { desc = 'Divide code chunk' })
-- )

-- Toggle diagnostics on/off
map('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = 'Toggle diagnostics' })

-- Paste line above/below preserving cursor
map('n', '<leader>p', 'm`o<ESC>p``', { desc = 'Paste line below' })
map('n', '<leader>P', 'm`O<ESC>p``', { desc = 'Paste line above' })

------------------------------------------------------------
-- Insert mode mappings
------------------------------------------------------------

-- Delete word backwards and forward
map('i', '<C-h>', '<C-w>', opts)
map('i', '<C-l>', '<C-o>dw', opts)

-- Undo/redo breakpoints
map('i', '<C-u>', '<C-g>u', opts)
map('i', '<C-r>', '<C-g>U', opts)

-- Break undo at punctuation
for _, ch in ipairs { ',', '.', '!', '?', ';', ':' } do
  map('i', ch, ch .. '<c-g>u', opts)
end

------------------------------------------------------------
-- Miscellaneous
------------------------------------------------------------

-- Toggle hlsearch on Enter keypress
map('n', '<cr>', function()
  vim.cmd [[ echon '' ]]
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ''
  else
    return kc '<cr>'
  end
end, { expr = true })

-- Record Picker
map('n', '<leader>R', ':RecordPicker<cr>', { silent = false })
