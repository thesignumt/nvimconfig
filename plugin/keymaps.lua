---@diagnostic disable: missing-parameter
local set = vim.keymap.set
local unmap = function(modes, lhs)
  modes = type(modes) == 'string' and { modes } or modes
  lhs = type(lhs) == 'string' and { lhs } or lhs
  for _, mode in pairs(modes) do
    for _, l in pairs(lhs) do
      pcall(vim.keymap.del, mode, l)
    end
  end
end
local opts = { noremap = true, silent = true }
local kc = vim.keycode
--- mt: merge tables
--- Merges the contents of table t2 into table t1.
--- If keys overlap, values from t2 overwrite those in t1.
--- @param t1 table The first table (modified in place).
--- @param t2 table The second table (merged into t1).
--- @return table The merged table (same as t1).
local function mt(t1, t2)
  local out = {}
  -- Copy all fields from t1
  for k, v in pairs(t1) do
    out[k] = v
  end
  -- Override with fields from t2
  for k, v in pairs(t2) do
    out[k] = v
  end
  return out
end

-- DIY implementation for toggling comments
function _G.toggle_comment()
  local line = vim.api.nvim_get_current_line()
  local comment_string = vim.bo.commentstring:match '^(.*)%%s' or '//'

  if line:match('^%s*' .. vim.pesc(comment_string)) then
    -- Uncomment the line
    line = line:gsub('^%s*' .. vim.pesc(comment_string) .. '%s?', '')
  else
    -- Comment the line
    line = comment_string .. ' ' .. line
  end

  vim.api.nvim_set_current_line(line)
end

-- Copilot
-- set({ 'n', 'v' }, '<leader>cpc', ':CopilotChat<CR>', opts)
-- set({ 'n', 'v' }, '<leader>cpd', ':Copilot disable<CR>', opts)
-- set({ 'n', 'v' }, '<leader>cpe', ':Copilot enable<CR>', opts)
-- CodeCompanion
set(
  { 'n', 'v' },
  '<leader>cp',
  ':CodeCompanionChat<CR>',
  mt(opts, { desc = 'CodeCompanionChat' })
)

-- Jump to plugin management file
set(
  'n',
  '<leader>vpp',
  '<cmd>e ' .. vim.fn.stdpath 'config' .. '/init.lua' .. '<CR>',
  mt(opts, { desc = 'Jump to configuration file' })
)

set(
  { 'n', 'v' },
  '<leader>x',
  '<cmd>.lua<cr>',
  mt(opts, { desc = 'Execute line/selection' })
)
set(
  'n',
  '<leader><leader>x',
  '<cmd>so %<cr>',
  mt(opts, { desc = 'Execute file' })
)

-- toggle between tabwidth of 2 and 4
set('n', '<leader>tw', function()
  local new_width = vim.bo.tabstop == 2 and 4 or 2
  vim.bo.tabstop = new_width
  vim.bo.shiftwidth = new_width
  vim.bo.softtabstop = new_width
end, mt(opts, { desc = 'Toggle tab width between 2 and 4' }))

set({ 'n', 'v' }, '<C-A-k>', function()
  return vim.fn.mode() == 'n' and 'yyP' or 'yP'
end, { expr = true, desc = 'Yank and paste above' })
set({ 'n', 'v' }, '<C-A-j>', function()
  return vim.fn.mode() == 'n' and 'yyp' or 'ygv<Esc>p'
end, { expr = true, desc = 'Yank and paste below' })

-- newline up or down in normal mode then clears
-- the newline without yanking to clipboard
set('n', '<A-o>', 'o<Esc>0"_D', opts)
set('n', '<A-O>', 'O<Esc>0"_D', opts)

-- Disable continuations
-- set('n', '<C-A-o>', 'o<Esc>^Da', opts)
-- set('n', '<C-A-O>', 'O<Esc>^Da', opts)

-- Select all
set('n', '==', 'ggVG', mt(opts, { desc = 'Select entire buffer' }))
set(
  'n',
  '=p',
  'ggVGp',
  mt(opts, { desc = 'Replace whole file with clipboard' })
)

-- Copy entire buffer
set('n', 'yA', '<cmd>%yank<cr>', { desc = 'yank entire buffer' })

-- Oil
set(
  'n',
  '-',
  '<CMD>Oil --float<CR>',
  mt(opts, { desc = 'Open parent directory' })
)

-- Barbar
-- Move to previous/next
set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
set('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Pin/unpin buffer
set('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
set('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

-- flash
set('n', '<leader>ls', function()
  require('flash').jump()
end, mt(opts, { desc = 'Flash Jump' }))
set('n', '<leader>lt', function()
  require('flash').treesitter()
end, mt(opts, { desc = 'Flash Treesitter' }))
set('n', '<leader>lr', function()
  require('flash').treesitter_search()
end, mt(opts, { desc = 'Flash Treesitter Search' }))

-- Screenkey
set(
  'n',
  '<leader>kst',
  ':Screenkey toggle<CR>',
  mt(opts, { desc = 'toggle Screenkey' })
)
set(
  'n',
  '<leader>ksr',
  ':Screenkey redraw<CR>',
  mt(opts, { desc = 'redraw Screenkey' })
)

set('v', 'J', ":m '>+1<CR>gv=gv", opts)
set('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Do not move my cursor when joining lines.
set('n', 'J', function()
  vim.cmd [[
      normal! mzJ`z
      delmarks z
    ]]
end, {
  desc = 'join lines without moving cursor',
})

set('n', 'gJ', function()
  -- we must use `normal!`, otherwise it will trigger recursive mapping
  vim.cmd [[
      normal! mzgJ`z
      delmarks z
    ]]
end, {
  desc = 'join lines without moving cursor',
})
set('n', '<C-d>', '<C-d>zz', opts)
set('n', '<C-u>', '<C-u>zz', opts)
set('n', 'G', 'Gzz', opts)
set('n', 'n', 'nzzzv', opts)
set('n', 'N', 'Nzzzv', opts)

-- Yank into "+
-- stylua: ignore start
set({'n', 'v'}, '<leader>y', '\"+y', opts)
set('n', '<leader>Y', '\"+Y', opts)
-- stylua: ignore end

set(
  'n',
  '<leader>s',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  opts
)

-- Paste without overwriting register
set('v', 'p', '"_dP', opts)

-- Delete without yanking
set({ 'n', 'v' }, 'dn', '"_dd', mt(opts, { desc = 'blackhole delete' }))
set({ 'n', 'v' }, 'dN', 'k"_dd', mt(opts, { desc = 'blackhole delete' }))

-- Delete all marks
set(
  { 'n', 'v' },
  'dm',
  '<cmd>delm!<cr>kj',
  mt(opts, { desc = 'del all marks' })
)

-- Fast line navigation
set(
  { 'n', 'v' },
  'H',
  '^',
  mt(opts, { desc = 'Start of line (first non-blank)' })
)
set(
  { 'n', 'v' },
  'L',
  'g_',
  mt(opts, { desc = 'End of line (last non-blank)' })
)

-- Indent and keep selection in visual mode
set('v', '<', '<gv', opts)
set('v', '>', '>gv', opts)

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
-- set('i', '++', plusplus(), opts)
-- set('i', '+=', ' = <Esc>^yt=f=lpa+', opts)

-- Divide code chunk
set(
  'n',
  ';;',
  'O<Esc>33i- <Esc>:lua toggle_comment()<CR>',
  mt(opts, {
    desc = 'Divide code chunk',
  })
)

-- Roll line
set(
  'n',
  '<A-S-h>',
  '0x$p0',
  mt(opts, { desc = 'Roll line characters to the left' })
)
set(
  'n',
  '<A-S-l>',
  '$x0P',
  mt(opts, { desc = 'Roll line characters to the right' })
)

-- ZenMode keymaps
set('n', '<leader>u', ':ZenMode<CR>', opts)

-- file
set('n', '<leader>q', '<CMD>x<CR>', mt(opts, { desc = 'quit current window' }))
set('n', '<leader>Q', '<CMD>qa!<CR>', { silent = true, desc = 'quit neovim' })
set('n', '<leader>w', '<CMD>silent! write<CR>', opts)

-- Toggle hlsearch if it's on, otherwise just do "enter"
set('n', '<CR>', function()
  vim.cmd [[ echon '' ]]
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ''
  else
    return kc '<CR>'
  end
end, { expr = true })

-- Open file explorer
set(
  'n',
  '<leader>we',
  ':!explorer .<CR><CR>',
  mt(opts, { desc = 'open file explorer' })
)

-- Delete one word with a single key
set('i', '<C-h>', '<C-w>', opts)
set('i', '<C-l>', '<C-o>dw', opts)

-- Remap in insert mode for undo and redo
set('i', '<C-u>', '<C-g>u', opts)
set('i', '<C-r>', '<C-g>U', opts)

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ',', '.', '!', '?', ';', ':' }
for _, ch in ipairs(undo_ch) do
  set('i', ch, ch .. '<c-g>u')
end

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
set(
  'n',
  '<leader>cd',
  '<cmd>lcd %:p:h<cr><cmd>pwd<cr>',
  { desc = 'change cwd' }
)

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
set('n', '<leader>p', 'm`o<ESC>p``', { desc = 'paste below current line' })
set('n', '<leader>P', 'm`O<ESC>p``', { desc = 'paste above current line' })

set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = 'toggle diagnostics' })

set({ 'n' }, '<leader>R', ':RecordPicker<CR>', { silent = false })
local ls = require 'luasnip'

set({ 'i' }, '<C-K>', function()
  ls.expand()
end, { silent = true })
set({ 'i', 's' }, '<C-L>', function()
  ls.jump(1)
end, { silent = true })
set({ 'i', 's' }, '<C-J>', function()
  ls.jump(-1)
end, { silent = true })

set({ 'i', 's' }, '<C-E>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
