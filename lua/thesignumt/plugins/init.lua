return {
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
    },
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {
            dependencies_bin = {
                tinymist = "tinymist.cmd",
            },
        },
    },
}
