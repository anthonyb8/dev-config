-- This plugin automatically inserts the closing pair of brackets, quotes, or parentheses when you type the opening one.
return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
}
