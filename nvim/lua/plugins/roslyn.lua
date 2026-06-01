local function vscode_csharp_extension_root()
    local extensions = vim.fn.glob(vim.fn.expand("~/.vscode/extensions/ms-dotnettools.csharp-*-linux-x64"), true, true)
    if #extensions == 0 then
        return nil
    end

    table.sort(extensions)
    return extensions[#extensions]
end

local function roslyn_paths()
    -- Prefer VS Code's bundled C#/Razor bits. They are version-matched and are
    -- known to make Razor source-generator features work for this repo; the
    -- global roslyn-language-server tool attached but failed Razor hover/diagnostics.
    local vscode_root = vscode_csharp_extension_root()
    if vscode_root then
        local roslyn_root = vim.fs.joinpath(vscode_root, ".roslyn")
        local razor_root = vim.fs.joinpath(vscode_root, ".razorExtension")
        local server = vim.fs.joinpath(roslyn_root, "Microsoft.CodeAnalysis.LanguageServer")
        local razor_extension = vim.fs.joinpath(razor_root, "Microsoft.VisualStudioCode.RazorExtension.dll")
        local design_time = vim.fs.joinpath(razor_root, "Targets", "Microsoft.CSharpExtension.DesignTime.targets")

        if vim.uv.fs_stat(server) and vim.uv.fs_stat(razor_extension) and vim.uv.fs_stat(design_time) then
            return {
                server = server,
                razor_extension = razor_extension,
                design_time = design_time,
            }
        end
    end

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
        local tool_root = tool_roots[#tool_roots]
        return {
            server = vim.fs.joinpath(tool_root, "Microsoft.CodeAnalysis.LanguageServer"),
            razor_extension = vim.fs.joinpath(tool_root, "Microsoft.VisualStudioCode.RazorExtension.dll"),
            design_time = vim.fs.joinpath(tool_root, "Targets", "Microsoft.CSharpExtension.DesignTime.targets"),
        }
    end

    local mason_root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "roslyn", "libexec")
    return {
        server = vim.fs.joinpath(mason_root, "Microsoft.CodeAnalysis.LanguageServer"),
        razor_extension = vim.fs.joinpath(mason_root, "Microsoft.VisualStudioCode.RazorExtension.dll"),
        design_time = vim.fs.joinpath(mason_root, "Targets", "Microsoft.CSharpExtension.DesignTime.targets"),
    }
end

local function roslyn_cmd()
    local paths = roslyn_paths()

    return {
        paths.server,
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
        "--csharpDesignTimePath=" .. paths.design_time,
        "--sourceGeneratorExecutionPreference=Automatic",
        "--stdio",
        "--extension=" .. paths.razor_extension,
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
                -- Prefer the repo-level solution so Roslyn loads sibling projects
                -- as source instead of navigating into metadata-as-source stubs.
                local git_root = vim.fs.root(vim.api.nvim_get_current_buf(), ".git")
                local root_target = vim.iter(targets):find(function(target)
                    return git_root and vim.fs.dirname(target) == git_root
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
