return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			-- LSP keymap setup inside on_attach function
			local on_attach = function(client, bufnr)
				-- Enable LSP keymaps only for the current buffer (bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }

				-- Keymaps for LSP functionality
				-- Keymap for opening definition in a new vertical split
				vim.keymap.set("n", "gd", function()
					vim.cmd("vsplit") -- Open a vertical split
					vim.lsp.buf.definition() -- Go to the definition in the split
				end, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Show hover documentation
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Find references
				vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts) -- Show code actions
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts) -- Go to type definition
				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts) -- Show signature help
			end

			-- Language server configurations
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.solargraph.setup({
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			-- Setup for Bash LSP
			lspconfig.bashls.setup({
				capabilities = capabilities, -- if you're defining capabilities elsewhere
				-- on_attach = on_attach,
				-- flags = {
				--   debounce_text_changes = 150,  -- Optional debounce setting
				-- }
			})

			-- C++
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy" },
			})

			-- -- Python
			-- lspconfig.pyright.setup({
			--   capabilities = capabilities,
			--   on_attach = function(client, bufnr)
			--     client.server_capabilities.documentFormattingProvider = false  -- New field
			--     on_attach(client, bufnr)
			--   end,
			-- })
			-- Python
			lspconfig.pylsp.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false -- Disable formatting if needed
					on_attach(client, bufnr)
				end,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								enabled = false, -- Disable pycodestyle
							},
						},
					},
				},
			})

			-- Rust
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						inlayHints = {
							bindingModeHints = {
								enable = false,
							},
							chainingHints = {
								enable = true,
							},
							closingBraceHints = {
								enable = true,
								minLines = 25,
							},
							closureReturnTypeHints = {
								enable = "never",
							},
							lifetimeElisionHints = {
								enable = "never",
								useParameterNames = false,
							},
							maxLength = 25,
							parameterHints = {
								enable = true,
							},
							reborrowHints = {
								enable = "never",
							},
							renderColons = true,
							typeHints = {
								enable = true,
								hideClosureInitialization = false,
								hideNamedConstructor = false,
							},
						},
					},
				},
			})
		end,
	},

	-- Add the inlay-hints.nvim plugin
	{
		"MysticalDevil/inlay-hints.nvim",
		config = function()
			require("inlay-hints").setup({
				-- Your custom settings here (optional)
				renderer = "inlay-hints", -- You can choose between 'inlay-hints' or 'lsp'
				-- e.g. hint_position = "right_align"
			})
		end,
	},
}
