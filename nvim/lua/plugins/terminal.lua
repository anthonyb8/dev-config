return {
  {
    "akinsho/toggleterm.nvim",
    version = "*", -- Use the latest stable version
    config = function()
      require("toggleterm").setup({
        size = 4,                 -- Size of the floating terminal
        open_mapping = [[<C-t>]], -- Map Ctrl + t to open terminal
        hide_numbers = true,      -- Hide line numbers in terminal
        shade_filetypes = {},
        shade_terminals = true,   -- Dim non-active terminal windows
        shading_factor = 2,       -- Amount of dimming
        start_in_insert = true,   -- Start terminal in insert mode
        insert_mappings = true,   -- Apply insert mode mappings
        terminal_mappings = true, -- Apply terminal mode mappings
        persist_size = true,      -- Preserve the size of the terminal
        direction = "float",      -- Make the terminal float
        close_on_exit = true,     -- Close terminal window when process exits
        shell = "tmux",           -- Use the default shell
        float_opts = {
          border = "curved",      -- Border style for the floating window
          winblend = 0,
        },
      })
    end,
  }
}
