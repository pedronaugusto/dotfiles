require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true, desc = "Toggle breakpoint" })

-- Start/Continue debugging with <F5>
map("n", "<F5>", function() require('configs.dap').runPreLaunchTaskAndDebug() end, { silent = true, desc = "Start/Continue Debugging" })
