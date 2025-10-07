local g = vim.g
local o = vim.opt

-- +-------------------------------------------------------+
-- [                        leader                         ]
-- +-------------------------------------------------------+
g.mapleader = ' '
g.maplocalleader = ' '

-- +-------------------------------------------------------+
-- [                     general opts                      ]
-- +-------------------------------------------------------+
o.number = true
o.relativenumber = true
o.showmode = false
o.mouse = 'nvch'
o.clipboard = ''
o.breakindent = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = 'yes'
o.foldcolumn = '0'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldlevel = 99 -- keep folds open by default
o.foldlevelstart = 99
o.foldenable = true
o.updatetime = 250
o.timeoutlen = 250
o.splitright = true
o.splitbelow = true
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.inccommand = 'split'
o.cursorline = true
o.scrolloff = 10
o.colorcolumn = '90'
o.termguicolors = true
o.wrap = false
o.title = true
o.titlestring = 'nvim'
o.swapfile = false
o.backup = false
o.undofile = true
o.cmdheight = 1
o.sessionoptions =
  'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
o.shada = { "'10", '<0', 's10', 'h' }
o.spell = true

-- +-------------------------------------------------------+
-- [                     tab settings                      ]
-- +-------------------------------------------------------+
o.expandtab = true
local tab_size = 2
local function setTab(t)
  o.tabstop = t
  o.softtabstop = t
  o.shiftwidth = t
end
setTab(tab_size)

-- +-------------------------------------------------------+
-- [                      win borders                      ]
-- +-------------------------------------------------------+
o.winborder = 'rounded'
g.cmp_winborder = 'rounded'
g.have_nerd_font = true

-- +-------------------------------------------------------+
-- [                       clipboard                       ]
-- +-------------------------------------------------------+
g.syncclip = false
if g.syncclip then
  vim.schedule(function()
    o.clipboard = 'unnamedplus'
  end)
end

-- =============================
--      COPILOT
-- =============================
g.copilot_enabled = 0

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
    o.number = false
    o.relativenumber = false
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
