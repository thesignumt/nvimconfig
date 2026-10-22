return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        default_file_explorer = true,
        columns = {
            "icon",
            -- 'size',
            -- 'mtime',
        },
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
                return vim.tbl_contains({ ".." }, name)
            end,
        },
        win_options = {
            wrap = true,
            number = false,
            relativenumber = false,
        },
        float = {
            -- padding = 2,
            max_width = 0.3,
            max_height = 0.6,
            border = "rounded",
        },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function(_, opts)
        require("oil").setup(opts)
        local nmap = require("thesignumt.utils.map").nmap
        nmap("<leader>f", ":Oil --float<cr>", "oil")
    end,
}
