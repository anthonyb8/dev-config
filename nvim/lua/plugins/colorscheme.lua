return {
  {
    "eddyekofo94/gruvbox-flat.nvim",
    lazy = false, -- Disable lazy loading for this color scheme
    config = function()
      vim.opt.termguicolors = true
      vim.cmd("colorscheme gruvbox-flat")
      vim.opt.guicursor = {
        'n-v-c:ver25',
        'i-ci-ve:ver25',
        'r-cr:ver25',
        'o:ver25',
      }
    end,
  },
}
