return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },       -- Lazy load when the Trouble commands are used
  dependencies = { "nvim-lua/plenary.nvim" }, -- Ensure dependencies are loaded
  opts = {
    use_diagnostic_signs = true,              -- Enables diagnostic signs
  },
}
