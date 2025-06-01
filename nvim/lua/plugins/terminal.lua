return {
	{
		"akinsho/toggleterm.nvim",
		version = "*", -- Use the latest stable version
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-t>]], -- Map Ctrl + t to open terminal
				hide_numbers = true, -- Hide line numbers in terminal
				shade_filetypes = {},
				shade_terminals = true, -- Dim non-active terminal windows
				shading_factor = 2, -- Amount of dimming
				start_in_insert = true, -- Start terminal in insert mode
				insert_mappings = true, -- Apply insert mode mappings
				terminal_mappings = true, -- Apply terminal mode mappings
				persist_size = true, -- Preserve the size of the terminal
				close_on_exit = true, -- Close terminal window when process exits
				shell = vim.o.shell, -- Use the default shell
				shell_cmd = { vim.o.shell, "-l" },
				direction = "horizontal", -- Make the terminal float
				-- doesn't matter if direction is "float"
				size = 10,
				-- only matters if direction ="float"
				float_opts = {
					border = "curved",
					width = 80,
					height = 20,
					winblend = 0,
				},
			})
		end,
	},
}
