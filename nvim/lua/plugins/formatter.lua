local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

return {
	"mhartington/formatter.nvim",
	config = function()
		require("formatter").setup({
			logging = false,
			filetype = {
				-- System Managed - Depreciated in Mason
				rust = {
					function()
						return {
							exe = "rustfmt",
							args = { "--edition=2021" },
							stdin = true,
						}
					end,
				},
				c = {
					-- Clang format for C++
					function()
						return {
							exe = "clang-format", -- Ensure clang-format is installed
							args = { "--style=Google" },
							stdin = true,
						}
					end,
				},
				cpp = {
					-- Clang format for C++
					function()
						return {
							exe = "clang-format", -- Ensure clang-format is installed
							args = { "--style=Google" },
							stdin = true,
						}
					end,
				},
				h = {
					-- Clang format for C++
					function()
						return {
							exe = "clang-format", -- Ensure clang-format is installed
							args = { "--style=Google" },
							stdin = true,
						}
					end,
				},
				hpp = {
					-- Clang format for C++
					function()
						return {
							exe = "clang-format", -- Ensure clang-format is installed
							args = { "--style=Google" },
							stdin = true,
						}
					end,
				},
				-- Mason managed
				python = {
					-- Black formatter for Python
					function()
						return {
							exe = mason_bin .. "black", -- Ensure black is installed
							args = { "--fast", "--line-length", "79", "-" },
							stdin = true,
						}
					end,
				},
				lua = {
					-- Stylua formatter for Lua
					function()
						return {
							exe = mason_bin .. "stylua", -- Ensure Stylua is installed
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "-" },
							stdin = true,
						}
					end,
					-- Add other formatters for different filetypes if needed
				},
				html = {
					-- HTMLBeautify formatter for HTML
					function()
						return {
							exe = mason_bin .. "htmlbeautifier",
							args = { "--indent-size", "2" },
							stdin = true,
						}
					end,
				},
				sh = {
					-- Bash
					function()
						return {
							exe = mason_bin .. "shfmt",
							args = { "-i", "2" }, -- Example: indent with 2 spaces
							stdin = true,
						}
					end,
				},
				json = {
					-- JSON configuration using Prettier
					function()
						return {
							exe = mason_bin .. "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
							stdin = true,
						}
					end,
				},
				markdown = {
					-- md
					function()
						return {
							exe = mason_bin .. "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				javascript = {
					-- Js
					function()
						return {
							exe = mason_bin .. "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				javascriptreact = {
					-- Jsx
					function()
						return {
							exe = mason_bin .. "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				typescript = {
					function()
						return {
							exe = mason_bin .. "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				typescriptreact = {
					function()
						return {
							exe = mason_bin .. "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				css = {
					-- Jsx
					function()
						return {
							exe = mason_bin .. "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				xml = {
					function()
						return {
							exe = "xmllint",
							args = { "--format", "-" },
							stdin = true,
						}
					end,
				},
			},
		})

		-- Format on save
		vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = {
				"*.py",
				"*.rs",
				"*.c",
				"*.h",
				"*.cpp",
				"*.hpp",
				"*.sh",
				"*.json",
				"*.lua",
				"*.js",
				"*.jsx",
				"*.ts",
				"*.tsx",
				"*.md",
				"*.css",
				"*.xml",
			},
			command = "FormatWrite",
			group = "FormatAutogroup",
		})
	end,
}
