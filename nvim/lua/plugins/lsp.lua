return {
	-- Mason UI for for managing external tools
	-- https://github.com/mason-org/mason.nvim
	{ "williamboman/mason.nvim", lazy = false, config = true },

	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- Bridges Mason with lspconfig; disables auto-setup so you can configure manually
	-- https://github.com/mason-org/mason-lspconfig.nvim
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"jdtls",
			},
			automatic_installation = true,
			automatic_setup = false,
			automatic_enable = false, -- added to stop mutiple servers from starting
			-- automatic_enable = {
			-- 	exclude = { "jdtls" },
			-- },
			handlers = {}, -- your handlers remain empty to disable auto-setup
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},

	-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },

	{
		"MysticalDevil/inlay-hints.nvim",
		config = function()
			require("inlay-hints").setup({
				renderer = "inlay-hints",
			})
		end,
	},

	-- Java LSP
	{ "mfussenegger/nvim-jdtls" },

	-- Core LSP client config, with completion capabilities injected via cmp-nvim-lsp
	-- https://github.com/neovim/nvim-lspconfig
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
				solargraph = {},
				html = {},
				cssls = {},
				lua_ls = {},
				bashls = {},
				marksman = {},
				sourcekit = {
					cmd = { "sourcekit-lsp" },
					filetypes = { "swift", "objective-c", "objective-cpp" },
					root_dir = lspconfig.util.root_pattern("Package.swift", ".git"),
				},

				-- Javascript/Typescript
				ts_ls = {},

				-- C/C++
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--clang-tidy-checks=google-*",
						"--log=verbose",
						-- "--clang-tidy",
					},
					root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
					init_options = { clangdFileStatus = true },
					flags = { debounce_text_changes = 150 },
				},

				-- Python
				pyright = {
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						on_attach(client, bufnr)
					end,
				},

				-- Rust
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

			-- Java formatting
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.java",
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
}
