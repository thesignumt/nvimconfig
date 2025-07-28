vim.cmd [[
    aunmenu PopUp
    anoremenu PopUp.URL     gx
]]

local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })
vim.api.nvim_create_autocmd("MenuPopup", {
    pattern = "*",
    group = group,
    desc = "My Custom PopUp Setup",
    callback = function()
    end,
})
