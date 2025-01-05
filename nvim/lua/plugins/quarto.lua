-- -- plugins/quarto.lua
return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
			"jpalardy/vim-slime",
		},
		config = function()
			require("quarto").setup({
				debug = false,
				closePreviewOnExit = true,
				lspFeatures = {
					enabled = true, -- Enable LSP features
					chunks = "curly",
					languages = { "python" }, -- Only enable Python for now
					hover = {
						enabled = true,
					},
					definition = {
						enabled = true,
					},
					diagnostics = {
						enabled = true,
						triggers = {}, -- Linting triggered on save
					},
					completion = {
						enabled = true, -- Enable autocompletion
					},
				},
				codeRunner = {
					enabled = false, -- Disable the code running feature
				},
			})
		end,
	},
}

-- return {
-- 	{
-- 		"quarto-dev/quarto-nvim",
-- 		dependencies = {
-- 			"jmbuhr/otter.nvim",
-- 			"nvim-treesitter/nvim-treesitter",
-- 			"jpalardy/vim-slime",
-- 		},
-- 		config = function()
-- 			require("quarto").setup({
-- 				debug = false,
-- 				closePreviewOnExit = true,
-- 				lspFeatures = {
-- 					enabled = true,
-- 					chunks = "curly",
-- 					languages = { "r", "python", "julia", "bash", "html" },
-- 					diagnostics = {
-- 						enabled = true,
-- 						triggers = { "BufWritePost" },
-- 					},
-- 					completion = {
-- 						enabled = true,
-- 					},
-- 				},
-- 				codeRunner = {
-- 					enabled = false,
-- 					default_method = nil, -- 'molten' or 'slime'
-- 					ft_runners = {}, -- filetype to runner, e.g., `{ python = "molten" }`.
-- 					never_run = { "yaml" }, -- filetypes which are never sent to a code runner
-- 				},
-- 			})
--
-- 			-- Key mappings for Quarto Runner
-- 			local runner = require("quarto.runner")
-- 			vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "Run cell", silent = true })
-- 			vim.keymap.set("n", "<leader>ra", runner.run_all, { desc = "Run all cells", silent = true })
-- 			vim.keymap.set("n", "<leader>rA", runner.run_above, { desc = "Run cell and above", silent = true })
-- 			vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "Run line", silent = true })
-- 			vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "Run visual range", silent = true })
-- 			vim.keymap.set("n", "<leader>RA", function()
-- 				runner.run_all(true)
-- 			end, { desc = "Run all cells of all languages", silent = true })
-- 		end,
-- 	},
-- }
