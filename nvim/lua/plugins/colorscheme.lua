return {
	{
		"eddyekofo94/gruvbox-flat.nvim",
		lazy = false, -- Disable lazy loading for this color scheme
		config = function()
			vim.opt.termguicolors = true
			vim.cmd("colorscheme gruvbox-flat")

			-- Make background transparent
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

			-- Telescope transparency settings
			vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
			vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none" })

			-- Make signcolumn background transparent so it blends nicely with terminal bg
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

			vim.opt.guicursor = {
				"n-v-c:ver25",
				"i-ci-ve:ver25",
				"r-cr:ver25",
				"o:ver25",
			}
		end,
	},
}
