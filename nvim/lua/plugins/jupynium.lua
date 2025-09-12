return {
	{
		"kiyoon/jupynium.nvim",
		build = "uv pip install . --python=$HOME/.virtualenvs/jupynium/bin/python",

		-- ft = "ju.py", -- only load for notebooks
		dependencies = {
			"rcarriga/nvim-notify",
			"stevearc/dressing.nvim",
		},
		config = function()
			require("jupynium").setup({
				-- python_host = "python3",
				auto_start_server = {
					enable = false,
					file_pattern = { "*.ju.py" },
				},
				-- Add these Jupyter-specific settings
				jupyter_command = "jupyter",
				jupyter_notebook_command = "jupyter-notebook",
				default_notebook_URL = "localhost:8888",
				-- Add logging
				log_level = vim.log.levels.DEBUG,
			})

			-- keymaps for running cells
			vim.keymap.set("n", "<leader>ja", "<cmd>JupyniumStartAndAttachToServer<CR>")
			vim.keymap.set("n", "<leader>jx", "<cmd>JupyniumStartSync<CR>")
			vim.keymap.set("n", "<leader>rc", "<cmd>JupyniumExecuteSelectedCells<CR>")
			vim.keymap.set("n", "<leader>rn", "<cmd>JupyniumExecuteSelectedCellsAndMove<CR>")
			vim.keymap.set("n", "<leader>ra", "<cmd>JupyniumExecuteAllCells<CR>")
		end,
	},
}
