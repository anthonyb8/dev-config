return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				python = { "ruff" }, -- Python linters
				-- cpp = { "clang-tidy" }, -- C++ linters
				-- hpp = { "clang-tidy" }, -- C++ linters
				-- c = { "clang-tidy" }, -- C++ linters
				-- h = { "clang-tidy" }, -- C++ linters
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				-- rust = { "clippy" },             -- Rust linter
			}

			-- Auto-lint on save
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
