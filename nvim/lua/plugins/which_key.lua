return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      plugins = {
        marks = false,
        registers = false,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      show_help = true,
      show_keys = true,
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },

      -- Disable icons
      icons = {
        mappings = false, -- Disable all icons for key mappings
      },
    })
    wk.add({
      -- General
      { "<leader>e",  "<cmd>Neotree reveal toggle<CR>",                                                desc = "Sidebar",                                     mode = "n" },
      { "<leader>/",  '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', desc = "Comment",                                     mode = "v" },
      { "<leader>/",  "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",                 desc = "Comment",                                     mode = "n" },
      { "<leader>a",  ":!chmod +x %<CR>",                                                              desc = "Executable",                                  mode = "n" },
      { "<leader>\\", ":vsplit<CR>",                                                                   desc = "Vsplit" },
      { "<leader>d",  [["_d]],                                                                         desc = "Delete (No Copy)",                            mode = "n" },

      -- CMake
      { "<leader>m",  group = "CMake" }, -- group
      { "<leader>cm", "!cmake -S . -B build<CR>",                                                      desc = "Configure build" },
      { "<leader>mk", ":!cmake --build ./build<CR>",                                                   desc = "Build project" },

      -- Search and Replace mappings under <leader>z
      { "<leader>z",  group = "Search" }, -- group
      { "<leader>zs", ":/",                                                                            desc = "Search",                                      mode = "n" },
      { "<leader>zr", ":%s/",                                                                          desc = "Replace in whole file",                       mode = "n" },
      { "<leader>zn", ":%s/\\<C-r><C-w>/\\<C-r><C-w>/gI<Left><Left><Left>",                            desc = "Replace current word",                        mode = "n" },
      { "<leader>zc", ":%s///gc<Left><Left><Left>",                                                    desc = "Replace with confirmation",                   mode = "n" },

      -- Buffer-related key mappings under <leader>b
      { "<leader>b",  group = "Buffer" },
      { "<leader>bc", ":bdelete<CR>",                                                                  desc = "Close buffer",                                mode = "n" },
      { "<leader>bd", ":Bdelete<CR>",                                                                  desc = "Delete buffer",                               mode = "n" },
      { "<leader>bq", ":BufferKill<CR>",                                                               desc = "Kill buffer",                                 mode = "n" },

      -- Quickfix-related key mappings under <leader>c
      { "<leader>c",  group = "Quickfix" },
      { "<leader>co", ":vert copen | vertical resize 70<CR>",                                          desc = "Open quickfix list" },
      { "<leader>cc", ":cclose<CR>",                                                                   desc = "Close quickfix list" },
      { "<leader>cn", ":cnext<CR>",                                                                    desc = "Next item in quickfix list" },
      { "<leader>cp", ":cprev<CR>",                                                                    desc = "Previous item in quickfix list" },

      -- Git-related key mappings under <leader>g
      { "<leader>g",  group = "Git" },
      { "<leader>gs", "<cmd>G<CR>",                                                                    desc = "Git Status" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>",                                                           desc = "Git Diff" },
      { "<leader>gc", "<cmd>Gcommit<CR>",                                                              desc = "Git Commit" },
      { "<leader>gp", "<cmd>Gpush<CR>",                                                                desc = "Git Push" },
      { "<leader>gl", "<cmd>Gpull<CR>",                                                                desc = "Git Pull" },
      { "<leader>gg", "<cmd>LazyGit<CR>",                                                              desc = "LazyGit" },
      { "<leader>gh", ":Gitsigns preview_hunk<CR>",                                                    desc = "Preview Hunk" },
      { "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>",                                       desc = "Toggle Blame" },

      -- Harpoon-related key mappings under <leader>h
      { "<leader>h",  group = "Harpoon" },
      { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>",                               desc = "Add File to Harpoon" },
      { "<leader>ht", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",                        desc = "Toggle Harpoon Menu" },
      { "<leader>hr", "<cmd>lua require('harpoon.mark').rm_file()<CR>",                                desc = "Remove File from Harpoon" },
      { "1",          ":lua require('harpoon.ui').nav_file(1)<CR>",                                    desc = "Navigate to File 1",                          hidden = true },
      { "2",          ":lua require('harpoon.ui').nav_file(2)<CR>",                                    desc = "Navigate to File 2",                          hidden = true },
      { "3",          ":lua require('harpoon.ui').nav_file(3)<CR>",                                    desc = "Navigate to File 3",                          hidden = true },
      { "4",          ":lua require('harpoon.ui').nav_file(4)<CR>",                                    desc = "Navigate to File 4",                          hidden = true },

      -- Python Venv-related key mappings under <leader>s
      { "<leader>s",  group = "Python" },
      { "<leader>se", ":VenvSelect<CR>",                                                               desc = "Select Python Environment" },

      -- Telescope-related key mappings under <leader>f
      { "<leader>f",  group = "Files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>",                                                 desc = "Find File" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",                                                  desc = "Live Grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>",                                                desc = "Grep String" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",                                                    desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",                                                  desc = "Help Tags" },
      { "<leader>fd", "<cmd>TodoTelescope<CR>",                                                        desc = "ToDO Tags" },

      -- Trouble
      { "<leader>t",  group = "Trouble" },
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>",                                           desc = "Diagnostics (Trouble)" },
      { "<leader>tf", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                              desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>",                                   desc = "Symbols (Trouble)" },
      { "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",                    desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>tc", "<cmd>Trouble loclist toggle<cr>",                                               desc = "Location List (Trouble)" },
      { "<leader>tq", "<cmd>Trouble qflist toggle<cr>",                                                desc = "Quickfix List (Trouble)" },

      -- Navigate through Trouble items
      { "]x",         "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>",       desc = "Next Trouble item" },
      { "[x",         "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>",   desc = "Previous Trouble item" },
      {
        -- Nested mappings are allowed and can be added in any order
        -- Most attributes can be inherited or overridden on any level
        -- There's no limit to the depth of nesting
        mode = { "n", "v" },                          -- NORMAL and VISUAL mode
        { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
        { "<leader>w", "<cmd>w<cr>", desc = "Write" },
      }
    })
  end,
}
