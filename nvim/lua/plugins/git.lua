return {
	-- vim-fugitive for Git commands
	{
		"tpope/vim-fugitive",
		config = function() end,
	},

	-- gitsigns.nvim for inline Git signs and hunk navigation
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signcolumn = false, -- Disable sign column
				numhl = true, -- Highlight line numbers with git status colors
				linehl = false,
			})
		end,
	},

	-- LazyGit Plugin
	{
		"kdheepak/lazygit.nvim",
		config = function() end,
	},
}
