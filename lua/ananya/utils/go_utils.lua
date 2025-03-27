local M = {}

function M.get_project_go_version()
	-- Try to get Go version from go.mod
	local go_mod = vim.fn.findfile("go.mod", vim.fn.getcwd() .. ";")
	if go_mod ~= "" then
		local content = vim.fn.readfile(go_mod)
		for _, line in ipairs(content) do
			local version = line:match("^go%s+(%d+%.%d+%.?%d*)")
			if version then
				return version
			end
		end
	end

	-- Fallback to system Go version
	local version = vim.fn.system("go version"):match("go(%d+%.%d+%.?%d*)")
	return version
end

function M.get_go_bin_path()
	local version = M.get_project_go_version()

	if version then
		local paths = {
			vim.fn.expand("$HOME/.gvm/pkgsets/go" .. version .. "/global/bin"),
			vim.fn.expand("$HOME/.gvm/pkgsets/go" .. version:match("(%d+%.%d+)") .. "/global/bin"),
		}
		for _, path in ipairs(paths) do
			if vim.fn.isdirectory(path) == 1 then
				return path
			end
		end
	end
	return nil
end

function M.get_gopls_cmd()
	local go_bin_path = M.get_go_bin_path()
	if go_bin_path then
		local gopls_path = go_bin_path .. "/gopls"
		if vim.fn.executable(gopls_path) == 1 then
			return { gopls_path, "serve" }
		end
	end
	-- Fallback to system gopls if not found in GVM path
	if vim.fn.executable("gopls") == 1 then
		return { "gopls", "serve" }
	end
	return nil
end

return M
