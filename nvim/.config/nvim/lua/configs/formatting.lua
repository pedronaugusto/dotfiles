local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    cpp = { "clang-format" },
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    javascriptreact = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },
    python = { "isort", "black" },
  },

  format_on_save = {
    async = false,
    timeout_ms = 500,
    lsp_fallback = true,
  },

  notify_on_error = true,
}

require("conform").setup(options)
