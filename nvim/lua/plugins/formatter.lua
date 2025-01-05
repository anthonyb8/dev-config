return {
	"mhartington/formatter.nvim",
	config = function()
		require("formatter").setup({
			logging = false,
			filetype = {
				python = {
					-- Black formatter for Python
					function()
						return {
							exe = "black", -- Ensure black is installed
							args = { "--fast", "--line-length", "79", "-" },
							stdin = true,
						}
					end,
				},
				rust = {
					-- Rustfmt formatter for Rust
					function()
						return {
							exe = "rustfmt", -- Ensure rustfmt is installed
							args = { "--edition=2021" },
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
				lua = {
					-- Stylua formatter for Lua
					function()
						return {
							exe = "stylua", -- Ensure Stylua is installed
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
							exe = "htmlbeautify",
							args = { "--indent-size", "2" },
							stdin = true,
						}
					end,
				},
				sh = {
					-- Bash
					function()
						return {
							exe = "shfmt",
							rgs = { "-i", "2" }, -- Example: indent with 2 spaces
							stdin = true,
						}
					end,
				},
				json = {
					-- JSON configuration using Prettier
					function()
						return {
							exe = "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
							stdin = true,
						}
					end,
				},
				markdown = {
					-- md
					function()
						return {
							exe = "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				javascript = {
					-- Js
					function()
						return {
							exe = "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				javascriptreact = {
					-- Jsx
					function()
						return {
							exe = "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				typescript = {
					function()
						return {
							exe = "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						}
					end,
				},
				typescriptreact = {
					function()
						return {
							exe = "prettier",
							args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
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
				"*.cpp",
				"*.h",
				"*.hpp",
				"*.sh",
				"*.json",
				"*.lua",
				"*.js",
				"*.jsx",
				"*.ts",
				"*.tsx",
				"*.md",
			},
			command = "FormatWrite",
			group = "FormatAutogroup",
		})
	end,
}
