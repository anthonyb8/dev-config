return {

	-- Auto-completion plugin
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- Debug Adapter Protocol (DAP) for debugging support
	{
		"mfussenegger/nvim-dap",
		config = function()
			-- Example configuration for lldb with Rust
			local dap = require("dap")
			dap.adapters.lldb = {
				type = "executable",
				command = "/usr/local/opt/llvm/bin/lldb", -- macos(brew)y
				name = "lldb",
			}
			dap.configurations.rust = {
				{
					name = "Launch",
					type = "lldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
		end,
	},

	-- crates.nvim for managing Rust crates in Cargo.toml
	{
		"saecki/crates.nvim",
		dependencies = "hrsh7th/nvim-cmp",
		ft = { "rust", "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			crates.show()
		end,
	},

	-- nvim-cmp for autocompletion
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For LuaSnip users
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

	-- cmp-nvim-lsp for LSP-based completion
	{
		"hrsh7th/cmp-nvim-lsp",
	},

	-- LuaSnip for snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip", -- Bridge between LuaSnip and nvim-cmp
			"rafamadriz/friendly-snippets", -- Prebuilt snippets for various languages
		},
	},
}
