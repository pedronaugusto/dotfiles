return{
    cp_defaults = function()
        return {
            suggestion = {
                enable = false,
            },
            panel = {
                enable = false,
            },
        }
    end,
    cp_cmp_defaults = function()
        return {
            sources = {
                { name = "nvim_lsp", group_index = 2 },
                { name = "copilot",  group_index = 2 },
                { name = "luasnip",  group_index = 2 },
                { name = "buffer",   group_index = 2 },
                { name = "nvim_lua", group_index = 2 },
                { name = "path",     group_index = 2 },
            }
        }     
    end
}