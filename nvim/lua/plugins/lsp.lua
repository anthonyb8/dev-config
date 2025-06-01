return {
	-- Mason UI for for managing external tools
	{ "williamboman/mason.nvim", lazy = false, config = true },

	-- Bridges Mason with lspconfig; disables auto-setup so you can configure manually
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			automatic_installation = true,
			handlers = {}, -- disable auto-setup
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},

	-- Core LSP client config, with completion capabilities injected via cmp-nvim-lsp
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(client, bufnr)
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
			end

			local servers = {
				ts_ls = {},
				solargraph = {},
				html = {},
				lua_ls = {},
				bashls = {},
				marksman = {},
				sourcekit = {
					cmd = { "sourcekit-lsp" },
					filetypes = { "swift", "objective-c", "objective-cpp" },
					root_dir = lspconfig.util.root_pattern("Package.swift", ".git"),
				},
				clangd = {
					cmd = {
						vim.fn.stdpath("data") .. "/mason/bin/clangd",
						"--background-index",
						"--clang-tidy=false",
						"--log=verbose",
					},
					root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
					init_options = { clangdFileStatus = true },
					flags = { debounce_text_changes = 150 },
				},
				pyright = {
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						on_attach(client, bufnr)
					end,
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							inlayHints = {
								bindingModeHints = { enable = false },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true, minLines = 25 },
								closureReturnTypeHints = { enable = "never" },
								lifetimeElisionHints = {
									enable = "never",
									useParameterNames = false,
								},
								maxLength = 25,
								parameterHints = { enable = true },
								reborrowHints = { enable = "never" },
								renderColons = true,
								typeHints = {
									enable = true,
									hideClosureInitialization = false,
									hideNamedConstructor = false,
								},
							},
						},
					},
				},
			}

			for name, config in pairs(servers) do
				config.capabilities = capabilities
				config.on_attach = config.on_attach or on_attach
				lspconfig[name].setup(config)
			end

			-- Rust-specific error workaround
			for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
				local default_handler = vim.lsp.handlers[method]
				vim.lsp.handlers[method] = function(err, result, ctx, cfg)
					if err and err.code == -32802 then
						return
					end
					return default_handler(err, result, ctx, cfg)
				end
			end
		end,
	},

	{
		"MysticalDevil/inlay-hints.nvim",
		config = function()
			require("inlay-hints").setup({
				renderer = "inlay-hints",
			})
		end,
	},
}

-- return {
-- 	{
-- 		"williamboman/mason.nvim",
-- 		lazy = false,
-- 		config = function()
-- 			require("mason").setup()
-- 		end,
-- 	},
-- 	{
--
-- 		"williamboman/mason-lspconfig.nvim",
-- 		lazy = false,
-- 		opts = {
-- 			automatic_installation = true,
-- 			handlers = {},
-- 		},
-- 		config = function(_, opts)
-- 			print("[DEBUG] mason-lspconfig opts: handlers disabled")
-- 			require("mason-lspconfig").setup(opts)
-- 		end,
-- 	},
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		lazy = false,
-- 		config = function()
-- 			local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
-- 			local lspconfig = require("lspconfig")
--
-- 			-- LSP keymap setup inside on_attach function
-- 			local on_attach = function(client, bufnr)
-- 				-- Enable LSP keymaps only for the current buffer (bufnr)
-- 				local opts = { noremap = true, silent = true, buffer = bufnr }
--
-- 				-- Keymaps for LSP functionality
-- 				-- Keymap for opening definition in a new vertical split
-- 				vim.keymap.set("n", "gd", function()
-- 					vim.cmd("vsplit") -- Open a vertical split
-- 					vim.lsp.buf.definition() -- Go to the definition in the split
-- 				end, opts)
-- 				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Show hover documentation
-- 				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- Find references
-- 				vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts) -- Show code actions
-- 				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
-- 				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts) -- Go to type definition
-- 				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts) -- Show signature help
-- 			end
--
-- 			-- Language server configurations
-- 			lspconfig.ts_ls.setup({
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 			})
-- 			lspconfig.solargraph.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			lspconfig.html.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			lspconfig.lua_ls.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			-- Setup for Bash LSP
-- 			lspconfig.bashls.setup({
-- 				capabilities = capabilities,
-- 			})
-- 			lspconfig.marksman.setup({
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 			})
-- 			-- Swift
-- 			lspconfig.sourcekit.setup({
-- 				cmd = { "sourcekit-lsp" },
-- 				filetypes = { "swift", "objective-c", "objective-cpp" },
-- 				root_dir = lspconfig.util.root_pattern("Package.swift", ".git"),
-- 			})
--
-- 			-- C++
-- 			lspconfig.clangd.setup({
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 				cmd = {
-- 					vim.fn.stdpath("data") .. "/mason/bin/clangd", --"clangd", -- Ensure this points to the correct version (Mason or system)
-- 					"--background-index",
-- 					"--clang-tidy=false", -- Disable clang-tidy; enable if needed
-- 					"--log=verbose", -- Enable verbose logging for debugging
-- 				},
-- 				root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
-- 				init_options = {
-- 					clangdFileStatus = true, -- Enable file status updates
-- 					-- fallbackFlags = { "-std=c++17" }, -- Fallback to C++17 if flags are missing
-- 				},
-- 				flags = {
-- 					debounce_text_changes = 150, -- Avoid excessive diagnostics
-- 				},
-- 			})
--
-- 			-- lspconfig.clangd.setup({
-- 			-- 	capabilities = capabilities,
-- 			-- 	on_attach = on_attach,
-- 			-- 	cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy=false" },
-- 			-- 	root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
-- 			-- })
--
-- 			-- Python
-- 			lspconfig.pyright.setup({
-- 				capabilities = capabilities,
-- 				on_attach = function(client, bufnr)
-- 					client.server_capabilities.documentFormattingProvider = false -- New field
-- 					on_attach(client, bufnr)
-- 				end,
-- 			})
--
-- 			-- Rust
-- 			lspconfig.rust_analyzer.setup({
-- 				capabilities = capabilities,
-- 				on_attach = on_attach,
-- 				settings = {
-- 					["rust-analyzer"] = {
-- 						inlayHints = {
-- 							bindingModeHints = {
-- 								enable = false,
-- 							},
-- 							chainingHints = {
-- 								enable = true,
-- 							},
-- 							closingBraceHints = {
-- 								enable = true,
-- 								minLines = 25,
-- 							},
-- 							closureReturnTypeHints = {
-- 								enable = "never",
-- 							},
-- 							lifetimeElisionHints = {
-- 								enable = "never",
-- 								useParameterNames = false,
-- 							},
-- 							maxLength = 25,
-- 							parameterHints = {
-- 								enable = true,
-- 							},
-- 							reborrowHints = {
-- 								enable = "never",
-- 							},
-- 							renderColons = true,
-- 							typeHints = {
-- 								enable = true,
-- 								hideClosureInitialization = false,
-- 								hideNamedConstructor = false,
-- 							},
-- 						},
-- 					},
-- 				},
-- 			})
-- 			-- Work around for rust_analyzer: -32802 : serevr cancelled the request 11/14/2024 --
-- 			for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
-- 				local default_diagnostic_handler = vim.lsp.handlers[method]
-- 				vim.lsp.handlers[method] = function(err, result, context, config)
-- 					if err ~= nil and err.code == -32802 then
-- 						return
-- 					end
-- 					return default_diagnostic_handler(err, result, context, config)
-- 				end
-- 			end
-- 			--
-- 		end,
-- 	},
--
-- 	-- Add the inlay-hints.nvim plugin
-- 	{
-- 		"MysticalDevil/inlay-hints.nvim",
-- 		config = function()
-- 			require("inlay-hints").setup({
-- 				-- Your custom settings here (optional)
-- 				renderer = "inlay-hints", -- You can choose between 'inlay-hints' or 'lsp'
-- 				-- e.g. hint_position = "right_align"
-- 			})
-- 		end,
-- 	},
-- }
