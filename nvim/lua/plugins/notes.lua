-- In your lazy.nvim plugins table (e.g. ~/.config/nvim/lua/plugins/writing.lua)

return {
	-- Distraction-free writing
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>n", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
		},
		opts = {
			window = {
				width = vim.o.columns - 10,
				height = 0.95,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					cursorline = false,
					foldcolumn = "0",
				},
			},
		},
	},

	-- Better prose line wrapping & text flow
	{
		"preservim/vim-pencil",
		ft = { "markdown", "txt", "text" }, -- auto-enable for prose filetypes
		init = function()
			vim.g["pencil#wrapModeDefault"] = "soft" -- soft wrap (no hard line breaks)
		end,
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown", "txt", "text" },
				callback = function()
					vim.fn["pencil#init"]()
				end,
			})
		end,
	},
}
