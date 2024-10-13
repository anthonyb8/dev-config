return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",  -- Load when entering insert mode
    config = function()
      require("nvim-autopairs").setup {}
    end,
  }
}

