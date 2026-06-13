-- Markdown Preview Plugin
return {
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	build = "cd app && yarn install",
	-- 	init = function()
	-- 		vim.g.mkdp_filetypes = { "markdown" }
	-- 		vim.g.mkdp_browser = "firefox" -- or "chrome", "chromium"
	-- 	end,
	-- 	ft = { "markdown" },
	-- },
	-- {
	-- 	"MeanderingProgrammer/render-markdown.nvim",
	-- 	ft = { "markdown" },
	-- 	opts = {},
	-- },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
		ft = { "markdown" },
		opts = {},
		config = function()
			-- Force heading text color by overriding treesitter highlights
			vim.api.nvim_set_hl(0, "markdownH1", { fg = "#ffffff", bold = true })
			vim.api.nvim_set_hl(0, "markdownH2", { fg = "#e0e0e0" })
			vim.api.nvim_set_hl(0, "markdownH3", { fg = "#c0c0c0" })
			vim.api.nvim_set_hl(0, "markdownH4", { fg = "#a0a0a0" })
			vim.api.nvim_set_hl(0, "markdownH5", { fg = "#808080" })
			vim.api.nvim_set_hl(0, "markdownH6", { fg = "#606060" })

			-- Backgrounds: Gruvbox blue/aqua shades
			vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#458588" }) -- gruvbox blue
			vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#3d7879" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#356b6a" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#2d5e5b" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#25514c" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#1d443d" })

			require("render-markdown").setup({
				heading = {
					sign = false,
					enabled = true,
					render_modes = false,
					atx = true,
					setext = true,
					-- sign = true,
					icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
					position = "overlay",
					signs = { "󰫎 " },
					width = "block",
					min_width = 90,
					left_margin = 0,
					left_pad = 0,
					right_pad = 0,
					-- min_width = 0,
					border = false,
					border_virtual = false,
					border_prefix = false,
					above = "▄",
					below = "▀",
					backgrounds = {
						"RenderMarkdownH1Bg",
						"RenderMarkdownH2Bg",
						"RenderMarkdownH3Bg",
						"RenderMarkdownH4Bg",
						"RenderMarkdownH5Bg",
						"RenderMarkdownH6Bg",
					},
					foregrounds = {
						"RenderMarkdownH1",
						"RenderMarkdownH2",
						"RenderMarkdownH3",
						"RenderMarkdownH4",
						"RenderMarkdownH5",
						"RenderMarkdownH6",
					},
					custom = {},
				},
			})
		end,
	},
}
