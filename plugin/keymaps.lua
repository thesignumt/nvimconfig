---@diagnostic disable: missing-parameter

------------------------------------------------------------
-- Helpers
------------------------------------------------------------
local map = vim.keymap.set
local kc = vim.keycode
local opts = { noremap = true, silent = true }

-- Delete keymaps
local unmap = function(modes, lhs)
  modes = type(modes) == 'string' and { modes } or modes
  lhs = type(lhs) == 'string' and { lhs } or lhs
  for _, mode in pairs(modes) do
    for _, l in pairs(lhs) do
      pcall(vim.keymap.del, mode, l)
    end
  end
end

--- Merge tables (t2 overwrites t1 on key conflict)
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

---@return string
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
-- Plugins
------------------------------------------------------------
-- CodeCompanion
map(
  { 'n', 'v' },
  '<leader>cp',
  ':CodeCompanionChat<CR>',
  mt(opts, { desc = 'CodeCompanionChat' })
)

-- Oil
map(
  'n',
  '-',
  '<CMD>Oil --float<CR>',
  mt(opts, { desc = 'Open parent directory' })
)

-- Barbar
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

-- Flash
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
  '<leader>kst',
  ':Screenkey toggle<CR>',
  mt(opts, { desc = 'toggle Screenkey' })
)
map(
  'n',
  '<leader>ksr',
  ':Screenkey redraw<CR>',
  mt(opts, { desc = 'redraw Screenkey' })
)

-- ZenMode
map('n', '<leader>u', ':ZenMode<CR>', opts)

------------------------------------------------------------
-- File / Config
------------------------------------------------------------
map(
  'n',
  '<leader>vpp',
  '<cmd>e ' .. vim.fn.stdpath 'config' .. '/init.lua<CR>',
  mt(opts, { desc = 'Jump to configuration file' })
)
map('n', '<leader>q', '<CMD>x<CR>', mt(opts, { desc = 'quit current window' }))
map('n', '<leader>Q', '<CMD>qa!<CR>', { silent = true, desc = 'quit neovim' })
map('n', '<leader>w', '<CMD>silent! write<CR>', opts)
map(
  'n',
  '<leader>we',
  ':!explorer .<CR><CR>',
  mt(opts, { desc = 'open file explorer' })
)
map(
  'n',
  '<leader>cd',
  '<cmd>lcd %:p:h<cr><cmd>pwd<cr>',
  { desc = 'change cwd' }
)

------------------------------------------------------------
-- Editing
------------------------------------------------------------
-- Execute code
map(
  { 'n', 'v' },
  '<leader>x',
  '<cmd>.lua<cr>',
  mt(opts, { desc = 'Execute line/selection' })
)
map(
  'n',
  '<leader><leader>x',
  '<cmd>so %<cr>',
  mt(opts, { desc = 'Execute file' })
)

-- Toggle tab width
map('n', '<leader>tw', function()
  local new_width = vim.bo.tabstop == 2 and 4 or 2
  vim.bo.tabstop = new_width
  vim.bo.shiftwidth = new_width
  vim.bo.softtabstop = new_width
end, mt(opts, { desc = 'Toggle tab width between 2 and 4' }))

-- Yank & paste above/below
map({ 'n', 'v' }, '<C-A-k>', function()
  return vim.fn.mode() == 'n' and 'yyP' or 'yP'
end, { expr = true, desc = 'Yank and paste above' })
map({ 'n', 'v' }, '<C-A-j>', function()
  return vim.fn.mode() == 'n' and 'yyp' or 'ygv<Esc>p'
end, { expr = true, desc = 'Yank and paste below' })

-- Newline without yanking
map('n', '<A-o>', 'o<Esc>0"_D', opts)
map('n', '<A-O>', 'O<Esc>0"_D', opts)

-- Select all / Replace all
map('n', '==', 'ggVG', mt(opts, { desc = 'Select entire buffer' }))
map(
  'n',
  '=p',
  'ggVGp',
  mt(opts, { desc = 'Replace whole file with clipboard' })
)

-- Yank entire buffer
map('n', 'yA', '<cmd>%yank<cr>', { desc = 'yank entire buffer' })

-- Visual mode move lines
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Join lines without moving cursor
map('n', 'J', function()
  vim.cmd [[ normal! mzJ`z | delmarks z ]]
end, { desc = 'join lines without moving cursor' })
map('n', 'gJ', function()
  vim.cmd [[ normal! mzgJ`z | delmarks z ]]
end, { desc = 'join lines without moving cursor' })

-- Center screen after movement
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', 'G', 'Gzz', opts)
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- Clipboard yank
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map('n', '<leader>Y', '"+Y', opts)

-- Search & replace word
map(
  'n',
  '<leader>s',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  opts
)

-- Paste without overwriting
map('v', 'p', '"_dP', opts)

-- Blackhole delete
map({ 'n', 'v' }, 'dn', '"_dd', mt(opts, { desc = 'blackhole delete' }))
map({ 'n', 'v' }, 'dN', 'k"_dd', mt(opts, { desc = 'blackhole delete' }))

-- Delete all marks
map(
  { 'n', 'v' },
  'dm',
  '<cmd>delm!<cr>kj',
  mt(opts, { desc = 'del all marks' })
)

-- Line navigation
map({ 'n', 'v' }, 'H', '^', mt(opts, { desc = 'Start of line' }))
map({ 'n', 'v' }, 'L', 'g_', mt(opts, { desc = 'End of line' }))

-- Indent & keep selection
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Divide code chunk
map(
  'n',
  ';;',
  'O<Esc>33i- <Esc>:lua toggle_comment()<CR>',
  mt(opts, { desc = 'Divide code chunk' })
)

-- Roll line chars
map('n', '<A-S-h>', '0x$p0', mt(opts, { desc = 'Roll line chars left' }))
map('n', '<A-S-l>', '$x0P', mt(opts, { desc = 'Roll line chars right' }))

-- Toggle diagnostics
map('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = 'toggle diagnostics' })

-- Paste line above/below
map('n', '<leader>p', 'm`o<ESC>p``', { desc = 'paste below current line' })
map('n', '<leader>P', 'm`O<ESC>p``', { desc = 'paste above current line' })

------------------------------------------------------------
-- Insert mode
------------------------------------------------------------
-- Delete word
map('i', '<C-h>', '<C-w>', opts)
map('i', '<C-l>', '<C-o>dw', opts)

-- Undo/redo
map('i', '<C-u>', '<C-g>u', opts)
map('i', '<C-r>', '<C-g>U', opts)

-- Break undo at punctuation
for _, ch in ipairs { ',', '.', '!', '?', ';', ':' } do
  map('i', ch, ch .. '<c-g>u')
end

------------------------------------------------------------
-- Misc
------------------------------------------------------------
-- Toggle hlsearch on Enter
map('n', '<CR>', function()
  vim.cmd [[ echon '' ]]
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ''
  else
    return kc '<CR>'
  end
end, { expr = true })

-- Record Picker
map('n', '<leader>R', ':RecordPicker<CR>', { silent = false })
