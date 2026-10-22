local g = vim.g
local o = vim.opt

g.mapleader = " "
g.maplocalleader = " "

o.nu = true
o.rnu = true
o.nuw = 1
o.cursorline = true
o.cursorlineopt = "number"
o.termguicolors = true
o.signcolumn = "yes"
-- o.colorcolumn = "90"
o.cmdheight = 1
o.showmode = false

o.list = true
o.listchars = { tab = "» ", nbsp = "␣" }
-- o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

o.title = true
o.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

o.wrap = true
o.linebreak = true
o.breakindent = true
o.scrolloff = 6
o.linespace = 0

o.ignorecase = true
o.completeopt = "menu,menuone,noselect"

o.splitright = true
o.splitbelow = true

o.updatetime = 250
o.timeoutlen = 250

o.inccommand = "split"
o.shortmess:append "Is"

o.mouse = "nvch"
o.guicursor = ""
o.clipboard = ""

o.swapfile = false
o.backup = false
o.undofile = true

o.sessionoptions =
    "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

o.shada = { "'10", "<0", "s10", "h" }

o.spell = false

-- Don't have `o` add a comment
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove { "o", "r" }
    end,
})

o.expandtab = true
local tab_size = 4
o.tabstop = tab_size
o.softtabstop = tab_size
o.shiftwidth = tab_size

o.winborder = "rounded"
g.have_nerd_font = true

for _, mode in ipairs { "n", "x", "v", "o", "s", "i", "t" } do
    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
        if map.lhs:match "^gr." and map.lhs ~= "gr" then
            pcall(vim.keymap.del, mode, map.lhs)
        end
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        local nmap = require("thesignumt.utils.map").nmap
        nmap("<leader>la", vim.lsp.buf.code_action, "Code Actions", opts)
        nmap("<leader>ln", vim.lsp.buf.rename, "Rename", opts)
        nmap(
            "<leader>lk",
            vim.diagnostic.open_float,
            "Floating diagnostics",
            opts
        )
    end,
})

local augroup_term = vim.api.nvim_create_augroup("MyTermOpen", { clear = true })
local augroup_yank =
    vim.api.nvim_create_augroup("thesignumt-highlight-yank", { clear = true })

-- Disable line numbers in terminals
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup_term,
    callback = function()
        o.number = false
        o.relativenumber = false
    end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup_yank,
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
})
