return {
    -- LSP Config plugin
    {
        'neovim/nvim-lspconfig', -- Core LSP support
        dependencies = {
            'williamboman/mason.nvim',          -- For LSP management
            'williamboman/mason-lspconfig.nvim', -- Bridges Mason and nvim-lspconfig
            'hrsh7th/nvim-cmp',        -- The completion plugin
            'hrsh7th/cmp-nvim-lsp',    -- LSP source
            'hrsh7th/cmp-buffer',      -- Buffer source
            'hrsh7th/cmp-path',        -- Path source
            'hrsh7th/cmp-cmdline',     -- Cmdline source
            'saadparwaiz1/cmp_luasnip', -- Luasnip source
            {
                'L3MON4D3/LuaSnip',
                config = function ()
                    require("hbr.snippets")
                end
            },
            'rafamadriz/friendly-snippets'
        },
        config = function()
            require('mason').setup()

            -- require('mason-lspconfig').setup({
            --     ensure_installed = {
            --         "lua_ls"
            --     }
            -- })

            local on_attach = function(_, _)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

                vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
                vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
                vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
            end

            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, {})
            vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})

            require("lspconfig").lua_ls.setup {
                on_attach = on_attach
            }

            require("lspconfig").gopls.setup {
                on_attach = on_attach
            }

            require('lspconfig').omnisharp.setup({
                cmd = { "omnisharp" },  -- This assumes omnisharp is available in your PATH
                filetypes = { "cs", "razor" },
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                on_attach = on_attach
            })

            require('lspconfig').pyright.setup({
                on_attach = on_attach
            })

            require('lspconfig').clangd.setup({
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp", "cxx", "hxx" },
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                on_attach = on_attach
            })

            require('lspconfig').ts_ls.setup({
                on_attach = on_attach
            })

            -- require('roslyn').setup {
            --     cmd = {
            --         '--stdio';
            --         '--logLevel=Information',
            --         '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
            --         '--razorSourceGenerator=' .. vim.fs.joinpath(
            --         vim.fn.stdpath 'data' --[[@as string]],
            --         'mason',
            --         'packages',
            --         'roslyn',
            --         'libexec',
            --         'Microsoft.CodeAnalysis.Razor.Compiler.dll'
            --         ),
            --         '--razorDesignTimePath=' .. vim.fs.joinpath(
            --         vim.fn.stdpath 'data' --[[@as string]],
            --         'mason',
            --         'packages',
            --         'rzls',
            --         'libexec',
            --         'Targets',
            --         'Microsoft.NET.Sdk.Razor.DesignTime.targets'
            --         ),
            --     },
            --     config = {
            --         --[[ the rest of your roslyn config ]]
            --         handlers = require 'rzls.roslyn_handlers',
            --     },
            --     on_attach = on_attach
            -- }

            local ok, luasnip = pcall(require, "luasnip")
            if not ok then
                print("LuaSnip not found!")
                return
            end

            require("luasnip.loaders.from_vscode").lazy_load()

            local cmp = require('cmp')

            cmp.setup({
                -- Snippet expansion (you need a snippet engine, e.g., luasnip)
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                -- Key mappings for navigation and completion
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),

                -- Completion sources
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'cmdline' },
                    { name = 'luasnip' },
                },


                -- Formatting the completion items (optional)
                formatting = {
                    fields = { 'kind', 'abbr', 'menu' },
                    format = function(entry, vim_item)
                        vim_item.kind = string.format('%s', vim_item.kind)
                        vim_item.menu = ({
                            nvim_lsp = '[LSP]',
                            buffer = '[Buffer]',
                            path = '[Path]',
                            cmdline = '[Cmd]',
                            luasnip = '[Snippet]',
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })

        end,
    },
}

