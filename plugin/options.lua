local lspservers = {
  'clangd',
  'pyright',
}
vim.lsp.enable(lspservers)
-- require('lspconfig').pylsp.setup {
--   settings = {
--     pylsp = {
--       plugins = {
--         pycodestyle = {
--           enabled = false,
--         },
--       },
--     },
--   },
-- }

--- mt: merge tables
--- Merges the contents of table t2 into table t1.
--- If keys overlap, values from t2 overwrite those in t1.
--- @param t1 table The first table (modified in place).
--- @param t2 table The second table (merged into t1).
--- @return table The merged table (same as t1).
local function mt(t1, t2)
  local out = {}
  for k, v in pairs(t2) do
    out[k] = v
  end
  return out
end

vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'

local function is_in_list(x, list)
  for _, value in ipairs(list) do
    if value == x then
      return true
    end
  end
  return false
end
local tab = 4
local tab2 = { 'c', 'cpp', 'lua' }
if is_in_list(vim.bo.filetype, tab2) then
  tab = 2
end
vim.opt.expandtab = true
local function setTab(t)
  vim.opt.tabstop = t
  vim.opt.softtabstop = t
  vim.opt.shiftwidth = t
end
setTab(tab)

vim.opt.foldmethod = 'manual'

vim.opt.colorcolumn = '90'

vim.opt.termguicolors = true

vim.opt.wrap = true

vim.opt.title = true
vim.opt.titlelen = 0

vim.o.cmdheight = 1

vim.o.shell = 'pwsh'
vim.o.shellcmdflag =
  '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellpipe = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
vim.o.shellquote = ''
vim.o.shellxquote = ''

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf }
    -- vim.keymap.set('n', 'gd', function()
    --   vim.lsp.buf.definition()
    -- end, opts)
    -- vim.keymap.set('n', 'K', function()
    --   vim.lsp.buf.hover()
    -- end, opts)
    vim.keymap.set('n', '<leader>la', function()
      vim.lsp.buf.code_action()
    end, mt(opts, { desc = 'Code Actions' }))
    vim.keymap.set('n', '<leader>lr', function()
      vim.lsp.buf.rename()
    end, mt(opts, { desc = 'Rename' }))
    vim.keymap.set('n', '<leader>lk', function()
      vim.diagnostic.open_float()
    end, mt(opts, { desc = 'Open floating diag.' }))
    vim.keymap.set('n', '<leader>ln', function()
      vim.diagnostic.goto_next()
    end, mt(opts, { desc = 'Next diagnostic' }))
    vim.keymap.set('n', '<leader>lp', function()
      vim.diagnostic.goto_prev()
    end, mt(opts, { desc = 'Prev diagnostic' }))
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('MyTermOpen', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local job_id = 0
local function crtTerm()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 5)

  job_id = vim.bo.channel
  vim.fn.chansend(job_id, { 'cls\r\n' })
end
vim.keymap.set('n', '<leader>tt', crtTerm, { desc = 'Toggle Terminal' })

vim.keymap.set('n', '<leader><leader>time', function()
  vim.fn.chansend(job_id, { 'time ' .. vim.fn.expand '%:p' })
end)

vim.keymap.set('n', '<leader><leader>cppa', function()
  local p = vim.fn.expand '%:p'
  local n = vim.fn.expand '%:p:r'
  if job_id == 0 then
    crtTerm()
  end
  vim.fn.chansend(
    job_id,
    { 'cls && g++ ' .. p .. ' -o ' .. n .. ' && ' .. n .. '\r\n' }
  )
end)

-- LuaSnip configuration
local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Keymaps for snippet navigation
vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.expand_or_jump() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Custom C++ snippets
ls.add_snippets('cpp', {
  s('!cp', {
    t {
      '#include <bits/stdc++.h>',
      'using namespace std;',
      '',
      'int main() {',
      '\tios_base::sync_with_stdio(false);',
      '\tcin.tie(nullptr);',
      '',
      '\t',
    },
    i(1),
    t {
      '',
      '}',
    },
  }),
})

-- Enable snippets for C++ files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp',
  callback = function()
    vim.bo.filetype = 'cpp' -- Ensure filetype is set
    setTab(2)
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'config.py',
  callback = function()
    vim.diagnostic.disable(0) -- Disable diagnostics for the current buffer
  end,
})
