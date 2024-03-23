return {
    {
      "stevearc/conform.nvim",
      event = {"BufWritePre", "BufNewFile"},-- uncomment for format on save
      config = function()
        require "configs.formatting"
      end,
    },
  
    {
      "rust-lang/rust.vim",
      ft = {"rust"},  -- Load on Rust files     
      init = function()
        vim.g.rustfmt_autosave = 1
        vim.g.rustfmt_fail_silently = 1
      end  
    }
}