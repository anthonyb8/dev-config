-- Persistent Undo
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"

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
vim.opt.updatetime = 200  -- Set faster update time for CursorHold (300 ms)

-- Disable cursorline in insert mode
vim.cmd([[
  au InsertEnter * set nocursorline
  au InsertLeave * set cursorline
]])

-- Show diagnostics on hover
function ShowDiagnosticsHover()
  local opts = {
    focusable = false,
    border = 'rounded',
    source = 'always',
  }
  vim.diagnostic.open_float(nil, opts)
end

vim.cmd([[autocmd CursorHold * lua ShowDiagnosticsHover()]])
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua ShowDiagnosticsHover()<CR>', { noremap = true, silent = true })

-- Diagnostic signs with hollow/outline symbols
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" }) -- Hollow/outline error
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" }) -- Hollow/outline warning
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" }) -- Hollow/outline info
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" }) -- Hollow/outline hint (lightbulb)

-- clang-format for C/C++
vim.cmd([[autocmd FileType cpp,c,h setlocal formatprg=clang-format\ --style=Google]])

-- Disable automatic comment on new lines
vim.cmd("autocmd FileType * setlocal formatoptions-=ro")

-- Set the leader key to space
vim.g.mapleader = " "

-- Disable space from moving forward in normal mode
vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', { noremap = true, silent = true })

-- Yank to system clipboard
vim.api.nvim_set_keymap('n', 'y', '<Nop>', { noremap = true, silent = true }) -- Unmap single `y` in normal mode to avoid any popup
vim.api.nvim_set_keymap('n', 'yy', '"+yy', { noremap = true, silent = true }) -- Yank the whole line
vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })   -- Yank selection in visual mode
vim.api.nvim_set_keymap('n', 'yw', '"+yaw', { noremap = true, silent = true })

-- Map Alt + Left Arrow to go to the previous buffer (cycles in buffer)
vim.api.nvim_set_keymap('n', '<S-Left>', ':bprev<CR>', { noremap = true, silent = true })

-- Map Alt + Right Arrow to go to the next buffer (cycles in buffer)
vim.api.nvim_set_keymap('n', '<S-Right>', ':bnext<CR>', { noremap = true, silent = true })

-- Map Ctrl + Left Arrow to move to the left window (diff buffers)
vim.api.nvim_set_keymap('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })

-- Map Ctrl + Right Arrow to move to the right window (diff buffers)
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- ToggleTerm Keybindings (Normal and Insert modes)
vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-t>", "<Esc>:ToggleTerm direction=float<CR>", { noremap = true, silent = true })

-- Save and Scroll Keybindings
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })  -- Save file
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true }) -- Scroll down with centering
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true }) -- Scroll up with centering

-- Window Management Keybindings
vim.api.nvim_set_keymap("n", "Q", "<nop>", { noremap = true, silent = true })            -- Disable Ex mode
vim.api.nvim_set_keymap("v", "-", ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- Move selected line(s) up
vim.api.nvim_set_keymap("v", "=", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- Move selected line(s) down
vim.api.nvim_set_keymap("i", "<C-c>", "<Esc>", { noremap = true, silent = true })        -- Escape in insert mode
vim.api.nvim_set_keymap("v", "<Tab>", ">gv", { noremap = true, silent = true })          -- Indent selected block
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", { noremap = true, silent = true })        -- Un-indent selected block

-- Swap Splits (Window management)
vim.api.nvim_set_keymap('n', '<C-w><S-Left>', '<C-w>H', { noremap = true, silent = true })  -- Swap window to left
vim.api.nvim_set_keymap('n', '<C-w><S-Right>', '<C-w>L', { noremap = true, silent = true }) -- Swap window to right
vim.api.nvim_set_keymap('n', '<C-w><S-Up>', '<C-w>K', { noremap = true, silent = true })    -- Swap window to top
vim.api.nvim_set_keymap('n', '<C-w><S-Down>', '<C-w>J', { noremap = true, silent = true })  -- Swap window to bottom
