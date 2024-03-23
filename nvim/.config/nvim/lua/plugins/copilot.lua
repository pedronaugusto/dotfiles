return{
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = require("configs.copilot").cp_defaults(),
      },
    
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          {
            "zbirenbaum/copilot-cmp",
            config = function()
              require("copilot_cmp").setup()
            end,
          },
        },
        opts = require("configs.copilot").cp_cmp_defaults(),
      },
    
}