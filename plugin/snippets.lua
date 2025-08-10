local snippets_dir = vim.fn.stdpath 'config' .. 'snippets/'
require('luasnip').setup { enable_autosnippets = true }
require('luasnip.loaders.from_lua').load {
  paths = snippets_dir,
}

--  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local ls = require 'luasnip'

vim.keymap.set({ 'i' }, '<C-K>', function()
  ls.expand()
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-L>', function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set({ 'i', 's' }, '<C-J>', function()
  ls.jump(-1)
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-E>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
