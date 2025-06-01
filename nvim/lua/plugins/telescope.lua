return {
	-- Lazy load Telescope when a keymap is pressed
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope", -- Load Telescope when the 'Telescope' command is run
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						height = 0.8,
						width = 0.8,
						preview_cutoff = 120,
						horizontal = {
							preview_width = 0.5,
						},
					},
					results_title = false,
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
			})
		end,
	},
}
