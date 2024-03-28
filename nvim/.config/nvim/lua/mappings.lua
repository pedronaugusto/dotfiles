require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<F9>", function() require'dap'.toggle_breakpoint() end, { silent = true, desc = "Toggle breakpoint" })

-- Start/Continue debugging with <F5>
map("n", "<F5>", function() require('configs.dap').run_pre_launch_task_and_debug() end, { silent = true, desc = "Start/Continue Debugging" })

map("n", "<A-h>", function() require('smart-splits').resize_left() end, { silent = true, desc = "Resize Left" })
map("n", "<A-j>", function() require('smart-splits').resize_down() end, { silent = true, desc = "Resize Down" })
map("n", "<A-k>", function() require('smart-splits').resize_up() end, { silent = true, desc = "Resize Up" })
map("n", "<A-l>", function() require('smart-splits').resize_right() end, { silent = true, desc = "Resize Right" })

-- moving between splits
map("n", "<C-h>", function() require('smart-splits').move_cursor_left() end, { silent = true, desc = "Move Cursor Left" })
map("n", "<C-j>", function() require('smart-splits').move_cursor_down() end, { silent = true, desc = "Move Cursor Down" })
map("n", "<C-k>", function() require('smart-splits').move_cursor_up() end, { silent = true, desc = "Move Cursor Up" })
map("n", "<C-l>", function() require('smart-splits').move_cursor_right() end, { silent = true, desc = "Move Cursor Right" })
