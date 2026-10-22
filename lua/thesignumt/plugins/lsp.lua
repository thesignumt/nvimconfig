return {
    { -- LSP config
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            {
                "mason-org/mason.nvim",
                ---@module 'mason.settings'
                ---@type MasonSettings
                opts = {},
            },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        require("thesignumt.utils.map").map(
                            mode,
                            keys,
                            func,
                            { buffer = event.buf, desc = "LSP: " .. desc }
                        )
                    end

                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    map("gt", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                    -- map(
                    --   '<leader>ed',
                    --   require('telescope.builtin').lsp_document_symbols,
                    --   'document symbols'
                    -- )
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- <leader>wd = builtin.lsp_dynamic_workspace_symbols
                    -- <leader>th = toggle inlay hints
                end,
            })

            vim.diagnostic.config {
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = false,
                virtual_text = {
                    severity = {
                        min = vim.diagnostic.severity.WARN,
                    },
                    spacing = 2,
                    source = "if_many",
                },
                -- underline = { severity = vim.diagnostic.severity.ERROR },
                -- signs = {
                --   text = {
                --     [vim.diagnostic.severity.ERROR] = '󰅚 ',
                --     [vim.diagnostic.severity.WARN] = '󰀪 ',
                --     [vim.diagnostic.severity.INFO] = '󰋽 ',
                --     [vim.diagnostic.severity.HINT] = '󰌶 ',
                --   },
                -- },
            }

            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            local servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--cross-file-rename",
                        "--compile-commands-dir=.",
                        "--all-scopes-completion",
                        "--completion-style=detailed",
                        "--pch-storage=memory",
                        "--header-insertion=never",
                    },
                    filetypes = { "c", "cpp", "objc", "objcpp" },
                    root_markers = {
                        "compile_commands.json",
                        "Makefile",
                        ".git",
                    },
                    capabilities = capabilities,
                    init_options = {
                        fallbackFlags = { "-std=c17" },
                    },
                },
                zls = {
                    cmd = { "zls" },
                    filetypes = { "zig", "zir" },
                    root_markers = {
                        "build.zig",
                        "build.zig.zon",
                        ".git",
                    },
                    capabilities = capabilities,
                },
            }

            for name, config in pairs(servers) do
                vim.lsp.config(name, config)
            end

            -- Reuse the capabilities configured for nvim-cmp.
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
            })

            require("mason-tool-installer").setup {
                ensure_installed = { "stylua" },
            }

            require("mason-lspconfig").setup {
                ensure_installed = {
                    "clangd",
                    "zls",
                    "lua_ls",
                    "rust_analyzer",
                },
                automatic_enable = {
                    "clangd",
                    "zls",
                    "lua_ls",
                    "rust_analyzer",
                },
            }
        end,
    },
}
