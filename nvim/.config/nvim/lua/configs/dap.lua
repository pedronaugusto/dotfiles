local dap = require('dap')
local dapui = require('dapui')

local M = {}

local function find_workspace_file()
    local cwd = vim.fn.getcwd()
    local scan_result = vim.fn.globpath(cwd, "*.code-workspace")
    local workspace_path = vim.fn.split(scan_result, "\n")[1]
    return workspace_path and #workspace_path > 0 and workspace_path or nil
end

local function file_exists(path)
    local stat = vim.loop.fs_stat(path)
    return (stat and stat.type) ~= nil
end

local function load_config(workspace_path)
    local tasks, launches = {}, {}
    local cwd = vim.fn.getcwd()
    local content = {}

    if workspace_path and file_exists(workspace_path) then
        content = vim.fn.readfile(workspace_path)
        if #content > 0 then
            local workspace = vim.fn.json_decode(table.concat(content, "\n"))
            tasks = workspace.tasks and workspace.tasks.tasks or {}
            launches = workspace.launch and workspace.launch.configurations or {}
            return tasks, launches
        end
    end

    local launch_json_path = cwd .. "/.vscode/launch.json"
    local tasks_json_path = cwd .. "/.vscode/tasks.json"

    if file_exists(launch_json_path) then
        local launch_content = vim.fn.readfile(launch_json_path)
        if #launch_content > 0 then
            launches = vim.fn.json_decode(table.concat(launch_content, "\n")).configurations or {}
        end
    end

    if file_exists(tasks_json_path) then
        local tasks_content = vim.fn.readfile(tasks_json_path)
        if #tasks_content > 0 then
            tasks = vim.fn.json_decode(table.concat(tasks_content, "\n")).tasks or {}
        end
    end

    return tasks, launches
end

local function setup_debug_configs(launches)
    for _, launch in ipairs(launches) do
        if launch.type == "lldb" then
            dap.adapters.lldb = {
                type = 'executable',
                command = '/opt/homebrew/opt/llvm/bin/lldb-vscode',
                name = "lldb"
            }

            dap.configurations.cpp = dap.configurations.cpp or {}
            table.insert(dap.configurations.cpp, {
                name = launch.name,
                type = "lldb",
                request = "launch",
                program = launch.program,
                args = launch.args,
                cwd = launch.cwd,
                setupCommands = {
                    { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = true }
                },
                stopOnEntry = false,
                runInTerminal = false,
            })
        end
    end

    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

local function set_default_debug_config(selected_config)
    dap.configurations.cpp = { selected_config }
end

local function execute_task(taskLabel, tasks)
    for _, task in ipairs(tasks) do
        if task.label == taskLabel then
            local cmd = task.command .. " " .. table.concat(task.args, " ")
            local cwd = task.options.cwd

            print("Running PreLaunchTask:", cmd, "in", cwd)

            vim.fn.jobstart(cmd, {
                cwd = cwd,
                on_exit = function(j, return_val)
                    if return_val == 0 then
                        print("PreLaunchTask completed successfully.")
                        dap.continue()
                    else
                        print("PreLaunchTask failed with return code:", return_val)
                    end
                end,
            })
            return
        end
    end
    print("PreLaunchTask not found:", taskLabel)
end

function M.run_pre_launch_task_and_debug()
    local workspace_path = find_workspace_file()
    local tasks, launches = load_config(workspace_path)

    if not launches or #launches == 0 then
        print("Failed to load launch configurations.")
        return
    end

    local config_names = vim.tbl_map(function(launch) return launch.name end, launches)

    local function on_select(launch_name)
        if not launch_name then
            print("Debug configuration selection cancelled.")
            return
        end

        for _, config in ipairs(launches) do
            if config.name == launch_name then
                set_default_debug_config(config)
                if config.preLaunchTask then
                    execute_task(config.preLaunchTask, tasks)
                else
                    print("No preLaunchTask specified. Continuing to debug with selected configuration.")
                    dap.continue()
                end
                break
            end
        end
    end

    vim.ui.select(config_names, { prompt = 'Select a debug configuration:' }, on_select)
end

function M.setup()
    local workspace_path = find_workspace_file()
    local tasks, launches = load_config(workspace_path)

    if not tasks or not launches then
        print("Failed to load debug configurations.")
        return
    end

    setup_debug_configs(launches)
end

return M