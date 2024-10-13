return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- Switch to the new branch with user-defined searches
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("venv-selector").setup({
        -- Enable or disable specific search options
        search_venv_managers = true, -- Search for Poetry, Pipenv, virtualenvwrapper environments
        search_workspace = true,     -- Search the project directory for local `.venv`
        search = true,               -- Search in global locations (like home directory)
        dap_enabled = false,         -- Disable DAP integration unless needed

        -- Custom user-defined search options (new in 2024 version)
        search_patterns = {
          { dir = vim.fn.getcwd(),  pattern = "venv" },  -- Look in the project directory-- Define custom search patterns for locating environments
          { dir = vim.fn.getcwd(),  pattern = ".venv" }, -- Look in the project directory
          { dir = "~/venvs",        pattern = "*" },     -- Search for virtual environments in `~/venvs`
          { dir = "~/.virtualenvs", pattern = "*" },     -- Search in `.virtualenvs` globally
        },
      })
    end,
  }
}
