local dap = require('dap')
local dapui = require('dapui')

local M = {}

-- Util to find the .code-workspace file
local function find_workspace_file()
  local cwd = vim.fn.getcwd()
  local scan_result = vim.fn.globpath(cwd, "*.code-workspace")
  local workspace_path = vim.fn.split(scan_result, "\n")[1]
  return workspace_path and #workspace_path > 0 and workspace_path or nil
end

-- Util to load configurations from .code-workspace or from separate files
local function load_config(workspace_path)
  local content = workspace_path and vim.fn.readfile(workspace_path) or {}
  local workspace, tasks, launches

  if #content > 0 then
      workspace = vim.fn.json_decode(table.concat(content, "\n"))
      tasks = workspace.tasks and workspace.tasks.tasks
      launches = workspace.launch and workspace.launch.configurations
  else
      local cwd = vim.fn.getcwd()
      local launch_content = vim.fn.readfile(cwd .. "/.vscode/launch.json")
      local tasks_content = vim.fn.readfile(cwd .. "/.vscode/tasks.json")

      if #launch_content > 0 then
          launches = vim.fn.json_decode(table.concat(launch_content, "\n")).configurations
      end
      if #tasks_content > 0 then
          tasks = vim.fn.json_decode(table.concat(tasks_content, "\n")).tasks
      end
  end

  return tasks, launches
end

local function setup_debug_configs(tasks, launches)
  -- Example: Setup NVIM-DAP for C++ using launch configurations
  for _, launch in ipairs(launches) do
      if launch.type == "lldb" then
          dap.adapters.lldb = {
            type = 'executable',
            command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- Update to your lldb-vscode path
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

  -- Initialize DAP UI
  dapui.setup()
  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

local function setDefaultDebugConfig(selected_config)
  -- Assuming `selected_config` is a table representing the chosen debug configuration.
  -- Here you directly set this configuration as the default for DAP to use.
  -- Example configuration for 'cpp' filetype; adjust according to your project's language and needs.
  dap.configurations.cpp = { selected_config }
end


-- Execute a specified pre-launch task
local function executeTask(taskLabel, tasks)
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

function M.runPreLaunchTaskAndDebug()
    local workspace_path = find_workspace_file()
    local tasks, launches = load_config(workspace_path)

    if not launches or #launches == 0 then
        print("Failed to load launch configurations.")
        return
    end

    -- Extract configuration names for selection
    local config_names = vim.tbl_map(function(launch) return launch.name end, launches)

    -- Function to execute after selection
    local function on_select(launch_name)
        if not launch_name then
            print("Debug configuration selection cancelled.")
            return
        end
        
        -- Find selected configuration
        for _, config in ipairs(launches) do
            if config.name == launch_name then
                setDefaultDebugConfig(config)
                if config.preLaunchTask then
                    -- Execute the associated pre-launch task
                    executeTask(config.preLaunchTask, tasks)
                else
                    print("No preLaunchTask specified. Continuing to debug with selected configuration.")
                    dap.continue()
                end
                break
            end
        end
    end

    -- Prompt user to select a debug configuration
    vim.ui.select(config_names, { prompt = 'Select a debug configuration:' }, on_select)
end

function M.setup()
  local workspace_path = find_workspace_file()
  local tasks, launches = load_config(workspace_path)

  if not tasks or not launches then
      print("Failed to load debug configurations.")
      return
  end

  setup_debug_configs(tasks, launches)
end

return M