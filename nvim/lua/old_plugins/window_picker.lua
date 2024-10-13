return {
  {
    -- "s1n7ax/nvim-window-picker",
    -- lazy = true, -- Lazy load the plugin
    -- -- keys = {     -- These keymaps will trigger the loading of the plugin
    -- --   { "<leader>k", desc = "Pick a window" }
    -- -- },
    -- config = function()
    --   -- Plugin setup
    --   require("window-picker").setup({
    --     autoselect_one = true,
    --     include_current = false,
    --     filter_rules = {
    --       bo = {
    --         filetype = { "neo-tree", "neo-tree-popup", "notify" },
    --         buftype = { "terminal", "quickfix" },
    --       },
    --     },
    --     other_win_hl_color = "#e35e4f", -- Highlight color for window picker
    --   })
    --
    --   -- Define the keymap action that uses the window picker
    --   --   vim.keymap.set('n', '<leader>o', function()
    --   --     local picked_window_id = require('window-picker').pick_window()
    --   --     if picked_window_id then
    --   --       vim.api.nvim_set_current_win(picked_window_id)
    --   --     end
    --   --   end, { noremap = true, silent = true, desc = "Pick a window" })
    -- end,
  },
}
