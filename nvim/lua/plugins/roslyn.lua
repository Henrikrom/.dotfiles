return {
    {
        "seblyng/roslyn.nvim",
        commit = "dcd8422b9a6fd64abc374e9d43a6be24809ee3cc",
        cmd = "Roslyn",
        ft = { "cs", "razor" },
        init = function()
            vim.filetype.add({
                extension = {
                    razor = "razor",
                    cshtml = "razor",
                },
            })
        end,
        opts = {
            choose_target = function(targets)
                local cwd = vim.uv.cwd()

                local cwd_target = vim.iter(targets):find(function(target)
                    return vim.fs.dirname(target) == cwd
                end)

                if cwd_target then
                    return cwd_target
                end

                table.sort(targets, function(a, b)
                    return #vim.split(vim.fs.dirname(a), "/", { plain = true, trimempty = true })
                        < #vim.split(vim.fs.dirname(b), "/", { plain = true, trimempty = true })
                end)

                return targets[1]
            end,
        },
        config = function(_, opts)
            require("roslyn").setup(opts)

            vim.lsp.config("roslyn", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
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
    },
}
