-- return {
--   "stevearc/oil.nvim",
--   config = function()
--     local oil = require("oil")
--     oil.setup()
--     vim.keymap.set("n", "-", oil.toggle_float, {})
--   end,
-- }
--

return {
	"stevearc/oil.nvim",
	config = function()
		local oil = require("oil")
		oil.setup({
			default_file_explorer = true,
			columns = { "icon", "git_status", "columns", "git_signs" },
			float = {
				padding = 1,
				max_width = 30,
				max_height = 0.2,
				border = "rounded",
				win_options = { winblend = 0 },
				override = function(conf)
					local padding = 1
					local width = math.min(conf.width or 30, vim.o.columns) -- handle autosizing
					conf.row = 1
					conf.col = vim.o.columns - width - padding
					conf.zindex = 1000 -- optional: force to top
					return conf
				end,
			},
			preview_win = {
				update_on_cursor_moved = true,
				preview_method = "fast_scratch",
				disable_preview = function(filename)
					return false
				end,
				win_options = {},
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name)
					return name == ".DS_Store" or name == "thumbs.db" or name == ".git" or name == ".."
				end,
				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},
			},

			keymaps = {
				["<CR>"] = "actions.select",
				-- ["o"] = "actions.select",
				["v"] = { "actions.select", opts = { vertical = true } },
				["s"] = { "actions.select", opts = { horizontal = true } },
				["t"] = { "actions.select", opts = { tab = true } },
				["<BS>"] = "actions.parent",
			},
		})

		vim.keymap.set("n", "-", oil.toggle_float, {})
	end,
}
