return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      require('bufferline').setup({
        options = {
          numbers = "none",                -- No buffer numbers
          diagnostics = false,             -- No diagnostics icons
          show_buffer_close_icons = false, -- No close icons on buffers
          show_close_icon = false,         -- No global close icon
          separator_style = "thin",        -- Thin separators between buffers
          always_show_bufferline = true,   -- Keep bufferline visible when multiple buffers are open
          custom_filter = function(buf_number)
            -- Only show buffers that are listed and visible in windows
            return vim.fn.buflisted(buf_number) == 1 and vim.fn.bufwinnr(buf_number) ~= -1
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "",               -- No text, just the gap
              separator = true,        -- Adds the divider
              highlight = "Directory", -- Keep separator visible
              text_align = "center",
              padding = 0,             -- Adjust the padding
            },
          },
        },
      })
    end,
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
}
