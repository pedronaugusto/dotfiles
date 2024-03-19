local dap = require('dap')
local dapui = require('dapui')

local M = {}

-- Function to load debug configurations from launch.json
local function load_launch_config()
    local launch_json_path = vim.fn.getcwd() .. "/.vscode/launch.json" -- Considering current working directory
    local content = vim.fn.readfile(launch_json_path)

    if #content == 0 then
        print("Failed to open " .. launch_json_path)
        return
    end

    local decoded_content = vim.fn.json_decode(table.concat(content, "\n"))
    if decoded_content and decoded_content.configurations then
        for _, config in ipairs(decoded_content.configurations) do
            if config.type == "lldb" then
                dap.adapters.lldb = {
                    type = 'executable',
                    command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- Update to your lldb-vscode path
                    name = "lldb"
                }
                dap.configurations.cpp = {
                    {
                        name = config.name,
                        type = "lldb",
                        request = "launch",
                        program = config.program,
                        args = config.args,
                        cwd = config.cwd,
                        stopOnEntry = false,
                        runInTerminal = false,
                    }
                }
                break -- assuming you want the first found configuration
            end
        end
    end
end

local function setup_dapui()
  dapui.setup()  -- Customize the dapui setup as needed

  dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
  end
end

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
                      -- Start debugging after the task completes successfully
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
  local launch_config_path = ".vscode/launch.json"
  local tasks_config_path = ".vscode/tasks.json"

  local launch_config = vim.fn.json_decode(vim.fn.readfile(launch_config_path))
  local tasks_config = vim.fn.json_decode(vim.fn.readfile(tasks_config_path))

  if not launch_config or not tasks_config then
      print("Failed to load launch/tasks configuration.")
      return
  end

  -- Assuming first configuration is the target
  local preLaunchTaskLabel = launch_config.configurations[1].preLaunchTask

  if preLaunchTaskLabel then
      executeTask(preLaunchTaskLabel, tasks_config.tasks)
  else
      print("No preLaunchTask specified.")
      dap.continue()
  end
end

-- Initialize function that setups everything
function M.setup()
    load_launch_config()
    setup_dapui()
end

return M