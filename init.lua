require("ananya.core")
require("ananya.lazy")
require("ananya.utils.transparent").enable_transparency()
-- local go_utils = require("ananya.utils.go_utils")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- local go_bin_path = go_utils.get_go_bin_path()
		-- if go_bin_path then
		-- 	vim.env.PATH = vim.env.PATH .. ":" .. go_bin_path
		-- end
	end,
})
