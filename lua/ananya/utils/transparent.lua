local M = {}

function M.enable_transparency()
	local transparent_groups = {
		"Normal",
		"NormalFloat",
		"NormalNC",
		"SignColumn",
		"EndOfBuffer",
		"LineNr",
		"Folded",
		"NonText",
		"SpecialKey",
		"VertSplit",
		"StatusLine",
		"StatusLineNC",
	}

	for _, group in ipairs(transparent_groups) do
		vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
	end

	-- Set up indent-blankline highlights
	vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261", nocombine = true })
	vim.api.nvim_set_hl(0, "IblScope", { fg = "#9d7cd8", nocombine = true })
end

return M
