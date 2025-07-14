return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			local lint = require("lint")
			local formatter = require("formatter.config")

			-- Function to show LSP clients in brackets
			local function lsp_client_names()
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return "No LSP"
				end

				local names = {}
				for _, client in ipairs(clients) do
					table.insert(names, client.name)
				end
				return table.concat(names, ", ")
			end

			-- Function to show the active Python virtual environment name
			local function venv_name()
				local venv = vim.env.VIRTUAL_ENV
				if not venv then
					return ""
				end
				return "[" .. vim.fn.fnamemodify(venv, ":t") .. "]"
			end

			-- Show active linters for current filetype or "No Linters"
			local function linter_names()
				local ft = vim.bo.filetype
				local linters = lint.linters_by_ft[ft] or {}
				if #linters == 0 then
					return "No Linters"
				end
				return table.concat(linters, ", ")
			end

			-- Show first active formatter executable or "No Formatter"
			local function formatter_name()
				local ft = vim.bo.filetype
				local formatter_config = require("formatter.config").values.filetype[ft]

				if formatter_config and #formatter_config > 0 then
					local active_formatter = formatter_config[1]()
					if active_formatter.exe then
						-- Extract just the executable name, no full path
						return vim.fn.fnamemodify(active_formatter.exe, ":t")
					end
				end
				return "No Formatter"
			end
			-- Combined status for LSP, Linters, Formatter
			local function status_info()
				return "[" .. lsp_client_names() .. ", " .. linter_names() .. ", " .. formatter_name() .. "]"
			end

			require("lualine").setup({
				options = {
					theme = "auto", -- Adjust to match your setup
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true, -- Ensure lualine fills the entire width
					disabled_filetypes = { "NvimTree" }, -- Disable NeoTree from appearing in lualine
				},
				sections = {
					lualine_a = { "mode" }, -- Show 'NORMAL' or other modes in the bottom left
					lualine_b = {
						"branch",
						{ "diff", colored = true, symbols = { added = " ", modified = "~", removed = " " } },
						venv_name,
					},
					lualine_c = { { "filename", path = 1 } }, -- Empty to avoid showing filename here
					lualine_x = { "diagnostics", status_info, "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
