local leap = require("leap")
leap.add_default_mappings(true)
vim.keymap.del({ "x", "o" }, "x")
vim.keymap.del({ "x", "o" }, "X")