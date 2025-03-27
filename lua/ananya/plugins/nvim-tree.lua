return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
			-- Add this section for diagnostics
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				icons = {
					hint = "➤",
					info = "ℹ",
					warning = "⚠",
					error = "✖",
				},
			},
		})

		-- Create a function to open the tree and focus on the current file
		local function open_nvim_tree_and_focus()
			local api = require("nvim-tree.api")
			api.tree.toggle()
			vim.defer_fn(function()
				api.tree.find_file({ focus = true, open = true })
			end, 100) -- Delay to ensure the tree is open before finding the file
		end

		-- Create a custom command
		vim.api.nvim_create_user_command("NvimTreeFocusCurrentFile", open_nvim_tree_and_focus, {})

		-- Function to open file in new tab
		local function open_file_in_tab(node)
			-- Close the tree
			local api = require("nvim-tree.api")
			api.tree.close()
			-- Open file in new tab
			vim.cmd("tabe " .. node.absolute_path)
		end

		-- Function to open nvim-tree and set keymaps
		local function open_nvim_tree()
			local api = require("nvim-tree.api")

			api.tree.open()
			-- Set keymaps only for nvim-tree buffer
			vim.api.nvim_buf_set_keymap(0, "n", "t", "", {
				callback = function()
					local node = api.tree.get_node_under_cursor()
					if node.type == "file" then
						open_file_in_tab(node)
					end
				end,
				noremap = true,
				silent = true,
				desc = "Open file in new tab",
			})
		end

		-- Create custom commands
		vim.api.nvim_create_user_command("NvimTreeOpenWithTabs", open_nvim_tree, {})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		-- keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		keymap.set("n", "<leader>et", "<cmd>NvimTreeOpenWithTabs<CR>", { desc = "Open explorer with tab support" })
		keymap.set(
			"n",
			"<leader>ex",
			"<cmd>NvimTreeFocusCurrentFile<CR>",
			{ desc = "Open explorer and focus current file" }
		)
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
