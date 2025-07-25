-- Set the leader key to space
vim.g.mapleader = " "

-- Disable space from moving forward in normal mode
vim.api.nvim_set_keymap("n", "<Space>", "<Nop>", { noremap = true, silent = true })

-- Yank to system clipboard
vim.api.nvim_set_keymap("n", "y", "<Nop>", { noremap = true, silent = true }) -- Unmap single `y` in normal mode to avoid any popup
vim.api.nvim_set_keymap("n", "yy", '"+yy', { noremap = true, silent = true }) -- Yank the whole line
vim.api.nvim_set_keymap("v", "y", '"+y', { noremap = true, silent = true }) -- Yank selection in visual mode
vim.api.nvim_set_keymap("n", "yw", '"+yaw', { noremap = true, silent = true })

-- Map Alt + Left Arrow to go to the previous buffer (cycles in buffer)
vim.api.nvim_set_keymap("n", "<S-h>", ":bprev<CR>", { noremap = true, silent = true })

-- Map Alt + Right Arrow to go to the next buffer (cycles in buffer)
vim.api.nvim_set_keymap("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true })

-- Move left in a split screen
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })

-- Move right in a split screen
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Move down in a split screen
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })

-- Move up in a split screen
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

-- ToggleTerm Keybindings (Normal and Insert modes)
vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-t>", "<Esc>:ToggleTerm direction=float<CR>", { noremap = true, silent = true })

-- Save and Scroll Keybindings
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true }) -- Save file
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true }) -- Scroll down with centering
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true }) -- Scroll up with centering

-- Window Management Keybindings
vim.api.nvim_set_keymap("n", "Q", "<nop>", { noremap = true, silent = true }) -- Disable Ex mode
vim.keymap.set("v", "-", ":move '<-2<CR>gv-gv", { noremap = true, silent = true }) -- Move selected line(s) up
vim.keymap.set("v", "=", ":move '>+1<CR>gv-gv", { noremap = true, silent = true }) -- Move selected line(s) down
vim.api.nvim_set_keymap("i", "<C-c>", "<Esc>", { noremap = true, silent = true }) -- Escape in insert mode
vim.api.nvim_set_keymap("v", "<Tab>", ">gv", { noremap = true, silent = true }) -- Indent selected block
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", { noremap = true, silent = true }) -- Un-indent selected block

-- Swap Splits (Window management)
vim.api.nvim_set_keymap("n", "<C-w><S-Left>", "<C-w>H", { noremap = true, silent = true }) -- Swap window to left
vim.api.nvim_set_keymap("n", "<C-w><S-Right>", "<C-w>L", { noremap = true, silent = true }) -- Swap window to right
vim.api.nvim_set_keymap("n", "<C-w><S-Up>", "<C-w>K", { noremap = true, silent = true }) -- Swap window to top
vim.api.nvim_set_keymap("n", "<C-w><S-Down>", "<C-w>J", { noremap = true, silent = true }) -- Swap window to bottom

vim.api.nvim_set_keymap("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
