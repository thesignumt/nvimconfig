-- +-------------------------------------------------------+
-- [                        leader                         ]
-- +-------------------------------------------------------+
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- +-------------------------------------------------------+
-- [                     general opts                      ]
-- +-------------------------------------------------------+
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.mouse = 'a'
vim.opt.clipboard = ''
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 250
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.foldmethod = 'manual'
vim.opt.colorcolumn = '90'
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.title = true
vim.opt.titlelen = 0
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.o.cmdheight = 1
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
-- vim.o.guicursor = ''
vim.o.sessionoptions =
  'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- +-------------------------------------------------------+
-- [                     tab settings                      ]
-- +-------------------------------------------------------+
vim.opt.expandtab = true
local tab_size = 2
local function setTab(t)
  vim.opt.tabstop = t
  vim.opt.softtabstop = t
  vim.opt.shiftwidth = t
end
setTab(tab_size)

-- +-------------------------------------------------------+
-- [                      win borders                      ]
-- +-------------------------------------------------------+
vim.opt.winborder = 'rounded'
vim.g.cmp_winborder = 'rounded'
vim.g.have_nerd_font = true

-- +-------------------------------------------------------+
-- [                       clipboard                       ]
-- +-------------------------------------------------------+
vim.g.syncclip = false
if vim.g.syncclip then
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)
end

-- =============================
--      COPILOT
-- =============================
vim.g.copilot_enabled = 0

-- =============================
--      REMOVE OLD KEYMAPS
-- =============================
for _, mode in ipairs { 'n', 'x', 'v', 'o', 's', 'i', 't' } do
  for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
    if map.lhs:match '^gr.' and map.lhs ~= 'gr' then
      pcall(require('utils.map').unmap, mode, map.lhs)
    end
  end
end

-- =============================
--      LSP ATTACH KEYMAPS
-- =============================
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf }
    local nmap = require('utils.map').nmap
    nmap('<leader>la', vim.lsp.buf.code_action, 'Code Actions', opts)
    nmap('<leader>ln', vim.lsp.buf.rename, 'Rename', opts)
    nmap('<leader>lk', vim.diagnostic.open_float, 'Floating diagnostics', opts)
  end,
})

-- =============================
--      AUTOCMDS
-- =============================
local augroup_term = vim.api.nvim_create_augroup('MyTermOpen', { clear = true })
local augroup_yank =
  vim.api.nvim_create_augroup('thesignumt-highlight-yank', { clear = true })

-- Disable line numbers in terminals
vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup_term,
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup_yank,
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})
