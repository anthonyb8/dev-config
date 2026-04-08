return {
	"nvim-flutter/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		require("flutter-tools").setup({
			flutter_path = "/opt/flutter/bin/flutter",
			lsp = {
				on_attach = function(client, bufnr)
					local opts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "gd", function()
						vim.cmd("vsplit")
						vim.lsp.buf.definition()
					end, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
				end,
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			},
			flutter_run = {
				auto_reload = true,
			},
			dev_tools = {
				autostart = true,
			},
		})
	end,
}
