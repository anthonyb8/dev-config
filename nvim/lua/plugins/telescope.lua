return {
  -- Lazy load Telescope when a keymap is pressed
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope", -- Load Telescope when the 'Telescope' command is run
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            height = 0.8,          -- Adjust the height of the results window
            width = 0.8,           -- Adjust the width of the results window
            preview_cutoff = 120,  -- Maximum number of characters to display in the preview column
            horizontal = {
              preview_width = 0.5, -- Adjust the width of the preview column
            },
          },
          mappings = {
            i = {
              -- Insert mode mappings
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
            },
            n = {
              -- Normal mode mappings
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          -- Default configuration for builtin pickers goes here:
        },
        extensions = {
          -- Your extension configuration goes here:
        },
      })
    end,
  }
}
