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
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
})
vim.opt.signcolumn = "auto"

-- Spell complete
-- vim.opt.spell = true
-- vim.opt.spelllang = "en_us"

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

--Tabs
-- Use builtin tabline
-- Always override the tabline
vim.opt.tabline = "%!v:lua._tabline()"

_G._tabline = function()
	local s = ""
	local terminal_exists = false

	-- first pass: check if any terminal exists
	for i = 1, vim.fn.tabpagenr("$") do
		local winnr = vim.fn.tabpagewinnr(i)
		local bufnr = vim.fn.tabpagebuflist(i)[winnr]
		if vim.bo[bufnr].buftype == "terminal" then
			terminal_exists = true
			break
		end
	end

	-- if no terminal, hide tabline
	if not terminal_exists then
		return ""
	end

	-- otherwise, render all tabs
	for i = 1, vim.fn.tabpagenr("$") do
		local winnr = vim.fn.tabpagewinnr(i)
		local bufnr = vim.fn.tabpagebuflist(i)[winnr]
		local name = vim.fn.bufname(bufnr)

		-- terminal gets special label
		if vim.bo[bufnr].buftype == "terminal" then
			name = " Terminal"
		else
			name = vim.fn.fnamemodify(name, ":t")
			if name == "" then
				name = "[No Name]"
			end
		end

		-- highlight current tab
		if i == vim.fn.tabpagenr() then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end

		s = s .. " " .. i .. ": " .. name .. " "
	end

	s = s .. "%#TabLineFill#"
	return s
end
-- -- jdtls : java lsp
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "java",
-- 	callback = function()
-- 		require("jdtls.jdtls_setup").setup()
-- 	end,
-- })

-- Clipboard over OSC 52.
--
-- The keymaps yank into "+, which needs a provider. On a desktop that is
-- xclip or wl-copy; on the headless Arch box there is no display and neither
-- binary exists, so "+y quietly went nowhere. OSC 52 sends the text to the
-- terminal emulator instead of to a local clipboard daemon, which means it
-- crosses SSH and tmux and lands on the clipboard of the machine in front of
-- you.
--
-- Only when there is no real local clipboard to prefer: on macOS and on a
-- desktop session the native provider is better, because it supports reading
-- as well as writing.
local has_local_clipboard = vim.fn.has("mac") == 1
  or vim.env.DISPLAY ~= nil
  or vim.env.WAYLAND_DISPLAY ~= nil

if not has_local_clipboard then
  local osc52 = require("vim.ui.clipboard.osc52")

  -- Paste deliberately does not ask the terminal for its clipboard. Almost
  -- every terminal refuses an OSC 52 read by default, and a refusal is
  -- indistinguishable from a slow answer, so nvim blocks until it times out
  -- on every "+p. Reading back the unnamed register is instant and is what
  -- you actually want, since the last yank is what put the text there.
  local function paste_from_unnamed()
    return vim.split(vim.fn.getreg('"'), "\n")
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste_from_unnamed, ["*"] = paste_from_unnamed },
  }
end
