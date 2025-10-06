return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        {
            "mfussenegger/nvim-dap-python",
            config = function()
                local dap_python = require("dap-python")
                dap_python.setup("/usr/bin/python")
                dap_python.test_runner = "pytest"
            end
        }
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup()


        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set('n', '<F5>', dap.continue, {})
        vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, {})
        vim.keymap.set('n', '<F10>', dap.step_over, {})
        vim.keymap.set('n', '<F11>', dap.step_into, {})
        vim.keymap.set('n', '<F12>', dap.disconnect, {})
        vim.keymap.set('n', '<F8>', dap.run_last, {})

        dap.adapters.coreclr = {
            type = 'executable',
            command = '/usr/local/netcoredbg',
            args = {'--interpreter=vscode'}
        }

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    -- helper to pick project
                    local function pick_project()
                        local projects = {}

                        -- if there's a solution, use dotnet sln list
                        local sln = vim.fn.glob("*.sln")
                        if sln ~= "" then
                            local handle = io.popen("dotnet sln " .. sln .. " list")
                            if handle then
                                for line in handle:lines() do
                                    if line:match("%.csproj$") then
                                        table.insert(projects, vim.fn.fnamemodify(line, ":p")) -- absolute path
                                    end
                                end
                                handle:close()
                            end
                        end

                        -- fallback: find all csproj files under cwd
                        if #projects == 0 then
                            projects = vim.fn.globpath(vim.fn.getcwd(), "**/*.csproj", false, true)
                        end

                        if #projects == 0 then
                            return nil
                        elseif #projects == 1 then
                            return projects[1]
                        else
                            -- show a numbered menu
                            local choices = { "Select project:" }
                            for _, proj in ipairs(projects) do
                                table.insert(choices, proj)
                            end
                            local choice = vim.fn.inputlist(choices)
                            if choice > 0 and choice <= #projects then
                                return projects[choice]
                            end
                        end
                        return nil
                    end

                    local csproj = pick_project()
                    if csproj then
                        local project_dir = vim.fn.fnamemodify(csproj, ":h")
                        local project_name = vim.fn.fnamemodify(csproj, ":t:r")
                        local dll = vim.fn.glob(project_dir .. "/bin/Debug/net*/" .. project_name .. ".dll")
                        if dll ~= "" and vim.fn.filereadable(dll) == 1 then
                            return dll
                        end
                    end

                    -- fallback: manual input
                    return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
                end,


                preLaunchTask = "dotnet build"
            }
        }

        dap.configurations.razor = dap.configurations.cs
    end,
}
