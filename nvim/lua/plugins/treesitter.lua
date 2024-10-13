return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Setup nvim-treesitter
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = { "python", "lua", "rust", "cpp", "javascript", "typescript" }, -- Add other languages you need
        auto_install = true,
        highlight = {
          enable = true,                             -- Enable Treesitter-based highlighting
          additional_vim_regex_highlighting = false, -- Disable built-in Vim regex highlighting
        },
        indent = { enable = true },                  -- Enable Treesitter-based indentation
        incremental_selection = {
          enable = true,                             -- Enable incremental selection
        },
      })

      -- Set folding to be handled by Treesitter and folds to be open by default
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use Treesitter for fold expression
      vim.opt.foldenable = true                       -- Enable folding
      vim.opt.foldlevel = 99                          -- Start with all folds open
    end,
  }
}
