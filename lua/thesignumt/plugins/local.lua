local m = require "thesignumt.utils.map"
local ms = m.modes
local nmap = m.nmap
local fn = require("thesignumt.utils.f").fn

return {
    {
        "mkcmt",
        dir = "~/Projects/mkcmt.nvim",
        ---@type MkcmtConfig
        opts = { default_header = "I USE NEOVIM BTW!!! :3" },
        config = function(_, opts)
            local mkcmt = require "mkcmt"
            mkcmt.setup(opts)

            local c = { after = true, upper = false }
            local C = { after = false, upper = false }
            local x = { after = true, upper = true }
            local X = { after = false, upper = true }

            ms("nv", m.dblL "c", fn(mkcmt.comment, c), "mkcmt after")
            ms("nv", m.dblL "C", fn(mkcmt.comment, C), "mkcmt before")
            ms("nv", m.dblL "x", fn(mkcmt.comment, x), "MKCMT after")
            ms("nv", m.dblL "X", fn(mkcmt.comment, X), "MKCMT before")
        end,
    },
    {
        "def",
        dir = "~/Projects/def.nvim",
        config = function()
            local def = require "def"
            def.setup {}

            nmap("<leader>iw", fn(def.lookup, "word"), "word def")
            nmap("<leader>is", fn(def.lookup, "lookup"), "search word def")
            nmap("<leader>if", fn(def.lookup, "favorites"), "search fav word def")
        end,
    },
    {
        "gruber-darker",
        dir = "~/Projects/gruber-darker.nvim",
        config = function()
            vim.cmd "colorscheme gruber-darker"
        end,
    },
    {
        "present",
        dir = "~/Projects/present.nvim",
    },
    {
        "cheada",
        dir = "~/Projects/cheada.nvim",
    },
}
