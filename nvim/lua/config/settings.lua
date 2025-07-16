-- Persistent Undo
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"

-- Removes tildes
vim.opt.fillchars:append({ eob = " " })

-- Push lualine down
vim.o.cmdheight = 0

-- Disable netrw if using another file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- General Settings
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.cursorline = true
vim.g.mapleader = " "

-- Faster popups for diagnostics on hover
vim.opt.updatetime = 200 -- Set faster update time for CursorHold (300 ms)

-- Disable cursorline in insert mode
vim.cmd([[
  au InsertEnter * set nocursorline
  au InsertLeave * set cursorline
]])

-- Show diagnostics on hover
function ShowDiagnosticsHover()
	local opts = {
		focusable = false,
		border = "rounded",
		source = "always",
	}
	vim.diagnostic.open_float(nil, opts)
end

vim.cmd([[autocmd CursorHold * lua ShowDiagnosticsHover()]])
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua ShowDiagnosticsHover()<CR>", { noremap = true, silent = true })

-- Diagnostic signs with hollow/outline symbols
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" }) -- Hollow/outline error
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" }) -- Hollow/outline warning
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" }) -- Hollow/outline info
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" }) -- Hollow/outline hint (lightbulb)

-- clang-format for C/C++
vim.cmd([[autocmd FileType cpp,c,h setlocal formatprg=clang-format\ --style=Google]])

-- Disable automatic comment on new lines
vim.cmd("autocmd FileType * setlocal formatoptions-=ro")

-- Lsp logs
vim.api.nvim_create_user_command("ClearLspLog", function()
	local log_path = vim.lsp.get_log_path()
	if log_path then
		os.execute("truncate -s 0 " .. log_path)
		print("LSP log cleared: " .. log_path)
	else
		print("No LSP log path found")
	end
end, {})

-- -- jdtls : java lsp
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "java",
-- 	callback = function()
-- 		require("jdtls.jdtls_setup").setup()
-- 	end,
-- })
