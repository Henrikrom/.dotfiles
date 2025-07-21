-- return {
--   {
--     'seblj/roslyn.nvim',
--     enabled = true,
--     ft = { 'cs', 'razor' },
--     dependencies = {
--       {
--         'tris203/rzls.nvim',
--         config = function()
--           require('rzls').setup({})
--         end,
--       },
--     },
--     config = function()
--       local on_attach = function(client, bufnr)
--         print("[Roslyn] attached to buffer " .. bufnr)
--
--         local opts = { buffer = bufnr }
--
--         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
--
--         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--         vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
--         vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
--         vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, opts)
--       end
--
--       require('roslyn').setup({
--         cmd = {
--           '--stdio',
--           '--logLevel=Information',
--           '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
--           '--razorSourceGenerator=' .. vim.fs.joinpath(
--             vim.fn.stdpath('data'),
--             'mason', 'packages', 'roslyn', 'libexec', 'Microsoft.CodeAnalysis.Razor.Compiler.dll'
--           ),
--           '--razorDesignTimePath=' .. vim.fs.joinpath(
--             vim.fn.stdpath('data'),
--             'mason', 'packages', 'rzls', 'libexec', 'Targets', 'Microsoft.NET.Sdk.Razor.DesignTime.targets'
--           ),
--         },
--
--         on_attach = on_attach,
--         capabilities = require("cmp_nvim_lsp").default_capabilities(),
--
--         handlers = require 'rzls.roslyn_handlers',
--
--         settings = {
--           ['csharp|inlay_hints'] = {
--             csharp_enable_inlay_hints_for_implicit_object_creation = true,
--             csharp_enable_inlay_hints_for_implicit_variable_types = true,
--             csharp_enable_inlay_hints_for_lambda_parameter_types = true,
--             csharp_enable_inlay_hints_for_types = true,
--             dotnet_enable_inlay_hints_for_indexer_parameters = true,
--             dotnet_enable_inlay_hints_for_literal_parameters = true,
--             dotnet_enable_inlay_hints_for_object_creation_parameters = true,
--             dotnet_enable_inlay_hints_for_other_parameters = true,
--             dotnet_enable_inlay_hints_for_parameters = true,
--             dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
--             dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
--             dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
--           },
--           ['csharp|code_lens'] = {
--             dotnet_enable_references_code_lens = true,
--           },
--         },
--       })
--     end,
--
--     init = function()
--       vim.filetype.add {
--         extension = {
--           razor = 'razor',
--           cshtml = 'razor',
--         },
--       }
--     end,
--   },
-- }

return {
    {
        "seblyng/roslyn.nvim",
        ft = { "cs", "razor" },
        dependencies = {
            {
                -- By loading as a dependencies, we ensure that we are available to set
                -- the handlers for Roslyn.
                "tris203/rzls.nvim",
                config = true,
            },
        },
        config = function()
            -- Use one of the methods in the Integration section to compose the command.
            local mason_registry = require("mason-registry")

            local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
            local cmd = {
                "roslyn",
                "--stdio",
                "--logLevel=Information",
                "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
                "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
                "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
                "--extension",
                vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
            }

            vim.lsp.config("roslyn", {
                cmd = cmd,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                handlers = require("rzls.roslyn_handlers"),
                settings = {
                    ["csharp|inlay_hints"] = {
                        csharp_enable_inlay_hints_for_implicit_object_creation = true,
                        csharp_enable_inlay_hints_for_implicit_variable_types = true,

                        csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                        csharp_enable_inlay_hints_for_types = true,
                        dotnet_enable_inlay_hints_for_indexer_parameters = true,
                        dotnet_enable_inlay_hints_for_literal_parameters = true,
                        dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                        dotnet_enable_inlay_hints_for_other_parameters = true,
                        dotnet_enable_inlay_hints_for_parameters = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                        dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                    },
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = true,
                    },
                },
            })
            vim.lsp.enable("roslyn")
        end,
        init = function()
            -- We add the Razor file types before the plugin loads.
            vim.filetype.add({
                extension = {
                    razor = "razor",
                    cshtml = "razor",
                },
            })
        end,
    },
}
