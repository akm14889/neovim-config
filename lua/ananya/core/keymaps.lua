-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })

-- Existing keymaps remain unchanged

-- Mouse-related keymaps
vim.api.nvim_set_keymap(
	"n",
	"<C-LeftMouse>",
	"<LeftMouse><Cmd>lua vim.lsp.buf.definition()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-RightMouse>",
	"<LeftMouse><Cmd>lua vim.lsp.buf.references()<CR>",
	{ noremap = true, silent = true }
)

-- LSP related keymaps
-- LSP related keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, noremap = true, silent = true }

		-- Go to definition
		-- Go to definition in a new tab
		keymap.set("n", "gd", function()
			vim.cmd("tab split")
			vim.lsp.buf.definition()
		end, vim.tbl_extend("force", opts, { desc = "Go to definition in new tab" }))
		-- Show hover information
		keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover information" }))

		-- Find references
		keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))

		-- Go to implementation
		keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			vim.tbl_extend("force", opts, { desc = "Go to implementation" })
		)

		-- Show signature help
		keymap.set(
			"n",
			"<C-k>",
			vim.lsp.buf.signature_help,
			vim.tbl_extend("force", opts, { desc = "Show signature help" })
		)

		-- Rename symbol
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

		-- Code action
		keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))

		-- Format code
		keymap.set("n", "<leader>f", vim.lsp.buf.format, vim.tbl_extend("force", opts, { desc = "Format code" }))

		-- Show diagnostic in a floating window
		keymap.set(
			"n",
			"<leader>e",
			vim.diagnostic.open_float,
			vim.tbl_extend("force", opts, { desc = "Show diagnostic" })
		)

		-- Go to next diagnostic
		keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))

		-- Go to previous diagnostic
		keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
	end,
})

-- Enhanced navigation keymaps
keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Scroll down and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Scroll up and center" })
keymap.set("n", "n", "nzzzv", { noremap = true, desc = "Next search result and center" })
keymap.set("n", "N", "Nzzzv", { noremap = true, desc = "Previous search result and center" })

-- Quick navigation between windows
keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, desc = "Move to bottom window" })
keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, desc = "Move to top window" })
keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, desc = "Move to right window" })
vim.api.nvim_set_keymap("i", "£", "#", { noremap = true })
vim.api.nvim_set_keymap("v", "X", '"_d', { noremap = true })

-- Go-specific keymaps (if you're using vim-go plugin)
keymap.set("n", "<leader>gr", "<cmd>GoRun<CR>", { noremap = true, desc = "Run Go program" })
keymap.set("n", "<leader>gt", "<cmd>GoTest<CR>", { noremap = true, desc = "Run Go tests" })
keymap.set("n", "<leader>gb", "<cmd>GoBuild<CR>", { noremap = true, desc = "Build Go program" })

vim.keymap.set("n", "<leader>mP", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
vim.keymap.set("n", "<leader>ms", ":MarkdownPreview<CR>", { desc = "Start Markdown Preview" })
vim.keymap.set("n", "<leader>mq", ":MarkdownPreviewStop<CR>", { desc = "Stop Markdown Preview" })

vim.keymap.set("n", "<leader>sC", function()
	require("telescope").extensions.diff.diff_files({ hidden = true })
end, { desc = "Compare 2 files" })
vim.keymap.set("n", "<leader>sc", function()
	require("telescope").extensions.diff.diff_current({ hidden = true })
end, { desc = "Compare file with current" })
