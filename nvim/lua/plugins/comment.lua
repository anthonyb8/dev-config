return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup({
        mappings = {
          basic = false, -- Disable gc/gb mappings
          extra = false, -- Disable more advanced mappings (like gco, gcO, gcA)
        }
      })
      vim.api.nvim_del_keymap('n', 'gc')
      vim.api.nvim_del_keymap('n', 'gcc')
      vim.api.nvim_del_keymap('v', 'gc')
    end,
  },
}
