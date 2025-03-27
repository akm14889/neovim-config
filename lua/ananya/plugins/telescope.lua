return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local action_state = require("telescope.actions.state")

		-- Custom action to open in new tab
		local open_in_new_tab = function(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			actions.close(prompt_bufnr)
			vim.cmd("tabnew " .. selection.value)
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<LeftMouse>"] = actions.select_default,
						["<RightMouse>"] = actions.close,
						["<C-t>"] = open_in_new_tab, -- Add this line
					},
					n = {
						["t"] = open_in_new_tab, -- Add this line
					},
				},
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("diff")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		-- Existing keymaps
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

		-- New keymaps for LSP functionality
		keymap.set("n", "<leader>fd", function()
			builtin.lsp_definitions()
		end, { desc = "Go to definition" })
		keymap.set("n", "<leader>fD", function()
			builtin.lsp_declarations()
		end, { desc = "Go to declaration" })
		keymap.set("n", "<leader>fi", function()
			builtin.lsp_implementations()
		end, { desc = "Go to implementation" })
		keymap.set("n", "<leader>fT", function()
			builtin.lsp_type_definitions()
		end, { desc = "Go to type definition" })
		keymap.set("n", "<leader>fR", function()
			builtin.lsp_references()
		end, { desc = "Find references" })
		keymap.set("n", "<leader>fS", function()
			builtin.lsp_document_symbols()
		end, { desc = "Document symbols" })
		keymap.set("n", "<leader>fW", function()
			builtin.lsp_workspace_symbols()
		end, { desc = "Workspace symbols" })

		-- Optional: Add this if you want to use Telescope for code actions
		keymap.set("n", "<leader>ca", function()
			builtin.lsp_code_actions()
		end, { desc = "Code actions" })
	end,
}

