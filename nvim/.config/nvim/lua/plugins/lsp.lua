return{
    {
        "neovim/nvim-lspconfig",
        config = function()
          require("nvchad.configs.lspconfig").defaults()
          require "configs.lspconfig"
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- cpp
                "clangd",
                --python
                "isort",
                "black",
                "pyright",
                --typescript
                "eslint-lsp",
                "prettier",
                "prettierd",
                "tailwindcss-language-server",
                "typescript-language-server",
                --rust
                "rust-analyzer",
            },
        },
    },
}