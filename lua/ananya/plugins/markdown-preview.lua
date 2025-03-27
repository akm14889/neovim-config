return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		-- Automatically install the plugin's dependencies
		if vim.fn["mkdp#util#install"] then
			vim.fn["mkdp#util#install"]()
		end
	end,
}
