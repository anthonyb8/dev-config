return {
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" }, -- Lazy-load when any of these commands are run
    config = function()
      require("todo-comments").setup({})
    end
  }
}
