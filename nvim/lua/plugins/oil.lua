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

					-- auto height based on file count
					local dir = require("oil").get_current_dir()
					if dir then
						local count = 0
						for _ in vim.fs.dir(dir) do
							count = count + 1
						end
						conf.height = math.min(count + 3, vim.o.lines - 2) -- +3 for border/padding, cap at screen height
					end

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
				-- ["v"] = { "actions.select", opts = { vertical = true } },
				["v"] = { "actions.select", opts = { vertical = true, split = "belowright" } },
				["s"] = { "actions.select", opts = { horizontal = true } },
				["t"] = { "actions.select", opts = { tab = true } },
				["<BS>"] = "actions.parent",
			},
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "oil",
			callback = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false

				-- resize float on every buffer change
				vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
					buffer = vim.api.nvim_get_current_buf(),
					callback = function()
						local win = vim.api.nvim_get_current_win()
						if not vim.api.nvim_win_is_valid(win) then
							return
						end

						local dir = require("oil").get_current_dir()
						if not dir then
							return
						end

						local count = 0
						for _ in vim.fs.dir(dir) do
							count = count + 1
						end

						local height = math.min(count + 1, vim.o.lines - 1)
						vim.api.nvim_win_set_config(win, { height = height })
					end,
				})
			end,
		})

		vim.keymap.set("n", "-", oil.toggle_float, {})
	end,
}
