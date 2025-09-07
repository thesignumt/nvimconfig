--  NOTE: Must happen before plugins are loaded (otherwise leader will be nil by default)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.winborder = 'rounded'
vim.g.cmp_winborder = 'rounded'
vim.g.syncclip = false
if vim.g.syncclip then
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)
end

-- Set to true if you have a Nerd Font installed and selected in the terminal
---@type boolean
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

-- NOTE: disabled mouse mode because i want to be like theprimeagen
vim.opt.mouse = ''

vim.opt.showmode = false -- already in status line

-- Enable break indent
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 250

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

vim.opt.cursorline = true -- highlight cursor line

vim.opt.scrolloff = 10

vim.g.copilot_enabled = 0

vim.api.nvim_set_hl(0, 'CmpBorder', { fg = '#20f6e2', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CmpDocBorder', { fg = '#20f6e2', bg = 'NONE' })

vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'

vim.opt.expandtab = true
vim.opt.foldmethod = 'manual'
vim.opt.colorcolumn = '90'
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.title = true
vim.opt.titlelen = 0
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undo'
vim.opt.undofile = true
vim.o.cmdheight = 1

local tab = 4
tab = vim.tbl_contains({ 'c', 'cpp', 'lua' }, vim.bo.filetype) and 2 or tab

local function setTab(t)
  vim.opt.tabstop = t
  vim.opt.softtabstop = t
  vim.opt.shiftwidth = t
end
setTab(tab)

for _, mode in ipairs { 'n', 'x', 'v', 'o', 's', 'i', 't' } do
  for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
    if map.lhs:match '^gr.' and map.lhs ~= 'gr' then
      pcall(require('utils.map').unmap, mode, map.lhs) -- pcall avoids errors if already removed
    end
  end
end

-- LSP Attach keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf }
    local nmap = require('utils.map').nmap
    nmap('<leader>la', vim.lsp.buf.code_action, 'Code Actions')
    nmap('<leader>ln', vim.lsp.buf.rename, 'Rename')
    nmap('<leader>lk', vim.diagnostic.open_float, 'Open floating diagnostics')
  end,
})

-- Disable line numbers in terminals
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('MyTermOpen', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup(
    'kickstart-highlight-yank',
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- local job_id = 0
-- local function crtTerm()
--   vim.cmd.vnew()
--   vim.cmd.term()
--   vim.cmd.wincmd 'J'
--   vim.api.nvim_win_set_height(0, 5)
--
--   job_id = vim.bo.channel
--   vim.fn.chansend(job_id, { 'cls\r\n' })
-- end

-- vim.keymap.set('n', '<leader>tt', crtTerm, { desc = 'Toggle Terminal' })

-- require('utils.map').nmap('<leader><leader>time', function()
--   vim.fn.chansend(job_id, { 'time ' .. vim.fn.expand '%:p' })
-- end)

-- Uncomment to enable compile+run keymap for cpp
-- vim.keymap.set('n', '<leader><leader>cppa', function()
--   local p = vim.fn.expand '%:p'
--   local n = vim.fn.expand '%:p:r'
--   if job_id == 0 then
--     crtTerm()
--   end
--   vim.fn.chansend(job_id, { 'cls && g++ ' .. p .. ' -o ' .. n .. ' && ' .. n .. '\r\n' })
-- end)
