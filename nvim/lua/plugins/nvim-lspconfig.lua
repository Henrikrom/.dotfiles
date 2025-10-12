return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                config = function()
                    require("hbr.snippets")
                end,
            },
            "rafamadriz/friendly-snippets",
        },

        config = function()
            -- Mason setup
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })

            -- Keymaps
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
            vim.keymap.set("n", "<leader>i", function()
                vim.lsp.buf.hover({ border = "rounded" })
            end, {})

            vim.api.nvim_create_autocmd("CursorHold", {
                callback = function()
                    vim.diagnostic.open_float(nil, { focus = false })
                end,
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local util = require("lspconfig.util")

            -- Define servers in the new framework
            vim.lsp.config["lua_ls"] = {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            }

            vim.lsp.config["gopls"] = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config["pyright"] = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config["clangd"] = {
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp", "cxx", "hxx" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config["ts_ls"] = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            vim.lsp.config["html"] = {
                root_dir = util.root_pattern(".git", "*.csproj", "*.sln") or function()
                    return vim.loop.cwd()
                end,
                filetypes = { "html", "razor", "cshtml" },
                on_attach = on_attach,
                capabilities = capabilities,
            }

            -- Enable servers
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("gopls")
            vim.lsp.enable("pyright")
            vim.lsp.enable("clangd")
            vim.lsp.enable("ts_ls")
            vim.lsp.enable("html")

            -- Snippet setup
            local ok, luasnip = pcall(require, "luasnip")
            if not ok then
                print("LuaSnip not found!")
                return
            end
            require("luasnip.loaders.from_vscode").lazy_load()

            -- nvim-cmp setup
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "cmdline" },
                    { name = "luasnip" },
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        vim_item.kind = string.format("%s", vim_item.kind)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            cmdline = "[Cmd]",
                            luasnip = "[Snippet]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })
        end,
    },
}

