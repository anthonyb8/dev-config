return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dap.set_log_level("DEBUG")

			require("dapui").setup({
				layouts = {
					{
						elements = {
							"scopes",
							"breakpoints",
							"stacks",
							-- "watches",
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							"repl",
							"console", -- Make sure this is here
						},
						size = 20,
						position = "bottom",
					},
				},
			})

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}

			-- Probe-rs DAP adapter
			dap.adapters["probe-rs"] = {
				type = "server",
				port = "${port}",
				executable = {
					command = "probe-rs",
					args = { "dap-server", "--port", "${port}" },
				},
			}

			-- require("dap.ext.vscode").type_to_filetypes["probe-rs"] = { "rust", "c", "cpp" }

			-- C/C++ Native and Embedded
			dap.configurations.c = {
				-- Native C debugging
				{
					name = "Launch (native)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = true,
					console = "integratedTerminal",
					env = {
						GLIBC_TUNABLES = "glibc.stdio.unbuffered=1",
					},
				},
				{
					name = "STM32 (Probe-rs)",
					type = "probe-rs",
					request = "launch",
					chip = "STM32F446RETx",
					-- stopOnEntry = false,
					-- runToMain = false, -- stop at main()
					continueAfterLaunch = true, -- this makes it start immediately
					coreConfigs = {
						{
							coreIndex = 0,
							programBinary = "/home/anthony/projects/stm_32/build/stm32.elf",
							rttEnabled = true, -- optional, remove if not using RTT
						},
					},
				},
			}
			dap.configurations.cpp = dap.configurations.c

			-- Native Rust
			dap.adapters["rust-gdb"] = {
				type = "executable",
				command = "rust-gdb",
				args = { "-q", "--interpreter=dap", "--eval-command", "set print pretty on" },
			}

			-- Probe-rs DAP adapter
			-- dap.adapters["probe-rs-debug"] = {
			-- 	type = "server",
			-- 	port = "${port}",
			-- 	executable = {
			-- 		command = "probe-rs",
			-- 		args = { "dap-server", "--port", "${port}" },
			-- 	},
			-- }

			-- Rust GDB adapter for embedded (arm-none-eabi-gdb)
			dap.adapters["arm-rust-gdb"] = {
				type = "executable",
				command = "arm-none-eabi-gdb",
				args = { "-i", "dap" },
			}

			-- Rust configurations
			dap.configurations.rust = {
				-- Native
				{
					name = "Launch (native Rust)",
					type = "rust-gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = true,
					stopAtBeginningOfMainSubprogram = true,
					-- console = "internalConsole",
					-- console = "integratedTerminal",
				},
				-- Normal debugging with RTT
				{
					name = "Debug STM32 (RTT + vars)",
					type = "probe-rs",
					request = "launch",
					chip = "STM32F446RETx",
					stopOnEntry = false,
					coreConfigs = {
						{
							coreIndex = 0,
							rttEnabled = true,
							programBinary = function()
								local crate_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
								return vim.fn.getcwd() .. "/target/thumbv7em-none-eabihf/debug/" .. crate_name
							end,
						},
					},
				},
				--  Hardware debugging (registers + memory)
				{
					name = "Debug STM32 (GDB mode)",
					type = "arm-gdb",
					request = "attach",
					target = "localhost:1337",
					stopOnEntry = false,
					program = function()
						local crate_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						return vim.fn.getcwd() .. "/target/thumbv7em-none-eabihf/debug/" .. crate_name
					end,
					cwd = "${workspaceFolder}",
				},
			}

			-- RTT listeners
			dap.listeners.before["event_probe-rs-rtt-channel-config"]["probe-rs-rtt"] = function(session, body)
				session:request("rttWindowOpened", { body.channelNumber, true })
			end

			dap.listeners.before["event_probe-rs-rtt-data"]["probe-rs-rtt"] = function(_, body)
				local repl = require("dap.repl")
				repl.append(body.data)
			end

			-- Auto open/close UI
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			-- dap.listeners.before.event_terminated.dapui_config = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited.dapui_config = function()
			-- 	dapui.close()
			-- end
		end,
	},
}
