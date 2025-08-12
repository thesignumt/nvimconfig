------------------------------------------------------------
-- LSP Servers Setup
------------------------------------------------------------

local lspservers = {
  'clangd',
  'pyright',
}
vim.lsp.enable(lspservers)

------------------------------------------------------------
-- General Vim Options
------------------------------------------------------------

vim.g.copilot_enabled = 0

vim.opt.winborder = 'rounded'

vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'

vim.opt.expandtab = true
vim.opt.foldmethod = 'manual'
vim.opt.colorcolumn = '90'
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.title = true
vim.opt.titlelen = 0
vim.o.cmdheight = 1
vim.o.swapfile = false

vim.o.shell = 'pwsh'
vim.o.shellcmdflag =
  '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
vim.o.shellpipe = '2>&1 | Tee-Object -FilePath %s; exit $LastExitCode'
vim.o.shellquote = ''
vim.o.shellxquote = ''

------------------------------------------------------------
-- Utility Functions
------------------------------------------------------------

-- Merge tables (t2 overwrites t1)
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

-- Check if value x is in list (array)
local function is_in_list(x, list)
  for _, v in ipairs(list) do
    if v == x then
      return true
    end
  end
  return false
end

------------------------------------------------------------
-- Filetype-specific Tab Settings
------------------------------------------------------------

local tab = 4
local tab2 = { 'c', 'cpp', 'lua' }
if is_in_list(vim.bo.filetype, tab2) then
  tab = 2
end

local function setTab(t)
  vim.opt.tabstop = t
  vim.opt.softtabstop = t
  vim.opt.shiftwidth = t
end
setTab(tab)

------------------------------------------------------------
-- Autocommands
------------------------------------------------------------
local modes = { 'n', 'x', 'v', 'o', 's', 'i', 't' } -- all relevant modes

for _, mode in ipairs(modes) do
  for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
    if map.lhs:match '^gr.' and map.lhs ~= 'gr' then
      pcall(vim.keymap.del, mode, map.lhs) -- pcall avoids errors if already removed
    end
  end
end

-- LSP Attach keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set(
      'n',
      '<leader>la',
      vim.lsp.buf.code_action,
      mt(opts, { desc = 'Code Actions' })
    )
    vim.keymap.set(
      'n',
      '<leader>lr',
      vim.lsp.buf.rename,
      mt(opts, { desc = 'Rename' })
    )
    vim.keymap.set(
      'n',
      '<leader>lk',
      vim.diagnostic.open_float,
      mt(opts, { desc = 'Open floating diagnostics' })
    )
    vim.keymap.set(
      'n',
      '<leader>ln',
      vim.diagnostic.goto_next,
      mt(opts, { desc = 'Next diagnostic' })
    )
    vim.keymap.set(
      'n',
      '<leader>lp',
      vim.diagnostic.goto_prev,
      mt(opts, { desc = 'Previous diagnostic' })
    )
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

-- Set tab to 2 for cpp files explicitly
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp',
  callback = function()
    vim.bo.filetype = 'cpp' -- Ensure correct filetype
    setTab(2)
  end,
})

------------------------------------------------------------
-- Terminal management
------------------------------------------------------------

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

-- Uncomment to enable compile+run keymap for cpp
-- vim.keymap.set('n', '<leader><leader>cppa', function()
--   local p = vim.fn.expand '%:p'
--   local n = vim.fn.expand '%:p:r'
--   if job_id == 0 then
--     crtTerm()
--   end
--   vim.fn.chansend(job_id, { 'cls && g++ ' .. p .. ' -o ' .. n .. ' && ' .. n .. '\r\n' })
-- end)
