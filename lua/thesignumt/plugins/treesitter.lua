return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "python",
                    "c",
                    "diff",
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                    "query",
                    "vim",
                    "vimdoc",
                    "zig",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    },
}
