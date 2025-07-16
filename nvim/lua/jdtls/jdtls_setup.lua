local M = {}

-- function M:setup()
function M.setup()
	-- Workspace
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local home = vim.fn.expand("~")
	local workspace_base = home .. "/projects/jdtls_data/"
	local workspace_dir = workspace_base .. project_name
	vim.fn.mkdir(workspace_base, "p")

	--Dynamic variables
	local java_exec = os.getenv("JAVA_HOME") and (os.getenv("JAVA_HOME") .. "/bin/java") or "java" -- fallback if JAVA_HOME not set
	local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar")

	-- local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

	-- Detect OS to pick correct config subfolder
	local config_os
	local uname = vim.loop.os_uname().sysname

	if uname == "Darwin" then
		config_os = "config_mac"
	elseif uname == "Linux" then
		config_os = "config_linux"
	elseif uname:match("Windows") then
		config_os = "config_win"
	else
		error("Unsupported OS for jdtls")
	end

	-- Final config path
	local config_path = jdtls_path .. "/" .. config_os

	-- 🔑 Inline on_attach and capabilities
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

	local config = {
		-- The command that starts the language server
		-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
		cmd = {

			-- 💀
			java_exec,
			-- "/usr/lib/jvm/java-21-openjdk/bin/java", -- or '/path/to/java17_or_newer/bin/java'
			-- depends on if `java` is in your $PATH env variable and if it points to the right version.

			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",
			"-jar",
			launcher_jar, -- Must point to the eclipse.jdt.ls installation
			"-configuration",
			config_path, -- Must point to the eclipse.jdt.ls installation
			"-data",
			workspace_dir,
		},

		-- 💀
		-- This is the default if not provided, you can remove it. Or adjust as needed.
		-- One dedicated LSP server & client will be started per unique root_dir
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "src" }),

		root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),

		-- Here you can configure eclipse.jdt.ls specific settings
		-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		-- for a list of options
		settings = {
			java = {},
		},

		-- Language server `initializationOptions`
		-- You need to extend the `bundles` with paths to jar files
		-- if you want to use additional eclipse.jdt.ls plugins.
		--
		-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
		--
		-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
		init_options = {
			bundles = {},
		},
		on_attach = on_attach,
		capabilities = capabilities,
	}
	-- This starts a new client & server,
	-- or attaches to an existing client & server depending on the `root_dir`.
	require("jdtls").start_or_attach(config)
end

return M
