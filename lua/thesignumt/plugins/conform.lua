return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },

    config = function()
        require("conform").setup {
            format_on_save = {
                timeout_ms = 5000,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                c = { "clang-format" },
                lua = { "stylua" },
                python = { "ruff_format" },
                zig = { "zigfmt" },
            },
            formatters = {
                stylua = {
                    prepend_args = {
                        "--indent-type",
                        "Spaces",
                        "--indent-width",
                        "4",
                    },
                },
                ["clang-format"] = {
                    prepend_args = {
                        "--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
                    },
                },
            },
        }
    end,
}
