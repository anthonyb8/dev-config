return {
	{
		"grafana/vim-alloy",
		ft = "alloy",
		config = function()
			vim.cmd([[
        autocmd FileType alloy setlocal foldmethod=syntax
      ]])
		end,
	},
}
