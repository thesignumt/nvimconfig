local M = {}

function M.setup()
    local function apply()
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#4d4d4d" })
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#565f73" })

        local hl = function(name)
            vim.api.nvim_set_hl(0, name, { fg = "#d0d0d0", bg = "#1a1a1a" })
        end

        hl "MiniStatuslineModeNormal"
        hl "MiniStatuslineModeInsert"
        hl "MiniStatuslineModeVisual"
        hl "MiniStatuslineModeReplace"
        hl "MiniStatuslineModeCommand"
        hl "MiniStatuslineModeOther"
    end

    apply()

    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = apply,
    })
end

return M
