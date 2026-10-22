return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter").setup()

            require("nvim-treesitter").install {
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
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "python",
                    "c",
                    "diff",
                    "lua",
                    "markdown",
                    "query",
                    "vim",
                    "vimdoc",
                    "zig",
                },
                callback = function(args)
                    vim.treesitter.start(args.buf)
                end,
            })
        end,
    },
}
