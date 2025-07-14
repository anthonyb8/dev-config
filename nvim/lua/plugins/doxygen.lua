-- C/C++ Documentation
return {
	"vim-scripts/DoxygenToolkit.vim",
	ft = { "c", "cpp", "h", "hpp" },
	config = function()
		vim.g.DoxygenToolkit_briefTag_pre = " @brief "
		vim.g.DoxygenToolkit_paramTag_pre = " @param "
		vim.g.DoxygenToolkit_returnTag = " @return "
	end,
}
