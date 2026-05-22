local function roslyn_root()
    local tool_roots = vim.fn.glob(
        vim.fs.joinpath(
            vim.fn.expand("~"),
            ".dotnet",
            "tools",
            ".store",
            "roslyn-language-server",
            "*",
            "roslyn-language-server.linux-x64",
            "*",
            "tools",
            "net10.0",
            "linux-x64"
        ),
        true,
        true
    )

    if #tool_roots > 0 then
        table.sort(tool_roots)
        return tool_roots[#tool_roots]
    end

    return vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "roslyn", "libexec")
end

local function roslyn_cmd()
    local roslyn_libexec = roslyn_root()

    return {
        vim.fs.joinpath(roslyn_libexec, "Microsoft.CodeAnalysis.LanguageServer"),
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
        "--csharpDesignTimePath="
            .. vim.fs.joinpath(roslyn_libexec, "Targets", "Microsoft.CSharpExtension.DesignTime.targets"),
        "--sourceGeneratorExecutionPreference=Automatic",
        "--stdio",
        "--extension=" .. vim.fs.joinpath(roslyn_libexec, "Microsoft.VisualStudioCode.RazorExtension.dll"),
    }
end

local function roslyn_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    capabilities.textDocument.semanticTokens = nil
    return capabilities
end

local function disable_roslyn_features(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.semanticTokensProvider = nil
end

local function roslyn_language_id(_, filetype)
    if filetype == "razor" or filetype == "cshtml" then
        return "aspnetcorerazor"
    end

    if filetype == "cs" then
        return "csharp"
    end

    return filetype
end

local function roslyn_root_dir(bufnr, on_dir)
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    if buf_name:match("^roslyn%-source%-generated://") then
        local existing_client = vim.lsp.get_clients({ name = "roslyn" })[1]
        if existing_client and existing_client.config.root_dir then
            on_dir(existing_client.config.root_dir)
            return
        end
    end

    local git_root = vim.fs.root(bufnr, ".git")
    if git_root then
        local root_solutions = vim.fs.find(function(name)
            return name:match("%.sln$") or name:match("%.slnx$") or name:match("%.slnf$")
        end, { path = git_root, type = "file", limit = 1 })

        if #root_solutions > 0 then
            on_dir(git_root)
            return
        end
    end

    local root_dir = require("roslyn.sln.utils").root_dir(bufnr)
    if root_dir then
        on_dir(root_dir)
    end
end

local function roslyn_handlers()
    local ok, default_handlers = pcall(require, "roslyn.lsp.handlers")
    local handlers = ok and default_handlers or {}

    return vim.tbl_extend("force", handlers, {
        ["textDocument/diagnostic"] = function(err, result, ctx, config)
            if
                err
                and err.code == -32000
                and err.message == "Couldn't get a source generator run result for project 'Miscellaneous Files'."
            then
                return
            end

            return vim.lsp.diagnostic.on_diagnostic(err, result, ctx, config)
        end,
    })
end

return {
    {
        "seblyng/roslyn.nvim",
        ft = { "cs", "razor" },
        init = function()
            vim.lsp.config("roslyn", {
                cmd = roslyn_cmd(),
                capabilities = roslyn_capabilities(),
                on_attach = disable_roslyn_features,
                get_language_id = roslyn_language_id,
                root_dir = roslyn_root_dir,
                handlers = roslyn_handlers(),
            })

            vim.filetype.add({
                extension = {
                    razor = "razor",
                    cshtml = "razor",
                },
            })
        end,
        opts = {
            choose_target = function(targets)
                local git_root = vim.fs.root(vim.api.nvim_get_current_buf(), ".git")

                local root_target = vim.iter(targets):find(function(target)
                    return vim.fs.dirname(target) == git_root
                end)

                if root_target then
                    return root_target
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
                cmd = roslyn_cmd(),
                capabilities = roslyn_capabilities(),
                on_attach = disable_roslyn_features,
                get_language_id = roslyn_language_id,
                root_dir = roslyn_root_dir,
                handlers = roslyn_handlers(),
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
        end,
    },
}
