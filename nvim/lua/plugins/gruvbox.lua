return {
	{
		-- "eddyekofo94/gruvbox-flat.nvim",
		"sainnhe/gruvbox-material",
		lazy = false, -- Disable lazy loading for this color scheme
		config = function()
			vim.opt.termguicolors = true
			vim.g.gruvbox_material_enable_italic = true
			vim.cmd.colorscheme("gruvbox-material")
			-- vim.cmd("colorscheme gruvbox-flat")

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

			-- Terminal specific
			vim.api.nvim_set_hl(0, "Terminal", { bg = "none" })
			vim.api.nvim_set_hl(0, "TermCursor", { bg = "none" })
			vim.api.nvim_set_hl(0, "TermCursorNC", { bg = "none" })

			-- -- Neo-tree transparency / background override
			-- vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })

			-- Match Neo-tree colors to Gruvbox Material
			vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#32302f" }) -- Gruvbox Bg0 / Fg1
			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "#32302f" })
			vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "#32302f" })
			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#7c6f64" }) -- slightly lighter for selection
			-- Make signcolumn background transparent so it blends nicely with terminal bg
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		end,
	},
}
