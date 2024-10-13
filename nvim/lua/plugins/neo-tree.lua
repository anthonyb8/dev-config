return {
  -- Lazy load Neo-tree when the keymap is pressed
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x", -- Ensure you are on the correct branch
  cmd = "Neotree", -- Load Neo-tree when the 'Neotree' command is executed

  dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  config = function()
    vim.o.splitright = true

    require("neo-tree").setup({
      close_if_last_window = false,                               -- Close Neo-tree if it's the last window
      window = {
        position = "right",
        width = 30,                                               -- Set the width of the Neo-tree window
        mappings = {
          ["<CR>"] = "open",                                      -- Open file
          ["o"] = "open",                                         -- Open file
          ["v"] = "open_vsplit",                                  -- Use 'v' to open file in vertical split
          ["s"] = "open_split",                                   -- Use 's' to open file in horizontal split
          ["t"] = "open_tabnew",                                  -- Use 't' to open file in new tab
          ["<C-w>"] = "close_node",                               -- Close node
          ["h"] = "close_node",                                   -- Close node
          ["l"] = "open",                                         -- Open file
          ["<BS>"] = "navigate_up",                               -- Navigate up
          ["<C-r>"] = "refresh",                                  -- Refresh Neo-tree
          ["a"] = { "add", config = { show_path = "relative" } }, -- Add file
          ["d"] = "delete",                                       -- Delete file
          ["r"] = "rename",                                       -- Rename file
          ["c"] = "copy",                                         -- Copy file
          ["m"] = "move",                                         -- Move file
        },
      },
      buffers = {
        follow_current_file = false, -- Follow current file in buffers view
      },
      filesystem = {
        follow_current_file = false, -- Follow current file in filesystem view
        filtered_items = {
          hide_dotfiles = false,     -- Hide dotfiles
          hide_gitignored = false,   -- Hide Git ignored files
          hide_by_name = {
            "node_modules",          -- Hide node_modules folder
            ".git"
          },
          never_show = {
            ".DS_Store", -- Never show .DS_Store files
            "thumbs.db", -- Never show thumbs.db files
            -- "__pycache__",
            ".git"
          },
        },
      },
      git_status = {
        enable = false,
        window = {
          position = "float", -- Position Git status window as a float
        },
      },
    })
  end
}
