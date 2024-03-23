return{
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
    },
    
    {
    "mfussenegger/nvim-dap",
        config = function()
            require('configs.dap').setup()
        end
    },
}