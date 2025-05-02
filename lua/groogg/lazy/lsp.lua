return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        -- Setup capabilities for LSP
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- Setup Mason for LSP installation management
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "ruff",
                "pyright",
            },
            handlers = {
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                -- Lua LSP specific configuration
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT'
                                },
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    library = {
                                        vim.env.VIMRUNTIME,
                                    }
                                },
                                format = {
                                    enable = true,
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                }
                            }
                        }
                    }
                end,

                -- Python configuration with Ruff
                ["ruff"] = function()
                    require("lspconfig").ruff.setup {
                        capabilities = capabilities,
                        init_options = {
                            settings = {
                                lint = {
                                    run = "onSave",
                                },
                                format = {
                                    args = {},
                                },
                            }
                        }
                    }
                end,

                ["pyright"] = function()
                    local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
                    require("lspconfig").pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            pyright = {
                                -- Using Ruff's import organizer
                                disableOrganizeImports = true,
                            },
                            python = {
                                pythonPath = venv_path,
                                analysis = {
                                    autoSearchPaths = true,
                                    autoImportCompletions = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true, },
                            },
                        }
                    }
                end,
            }
        })


        -- Setup nvim-cmp for completions
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter to confirm
                ['<C-Space>'] = cmp.mapping.complete(),
                --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                --     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                --     ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'path' },
            }, {
                { name = 'buffer' },
            })
        })

        -- Configure diagnostics
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
