return{
    {
        "neovim/nvim-lspconfig",
        config = function()
          require("nvchad.configs.lspconfig").defaults()
          require "configs.lsp"
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- cpp
                "clang-format",
                "clangd",
                --python
                "flake8",
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