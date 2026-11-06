return {
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
			vim.api.nvim_set_keymap("i", "<C-F>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-G>", "copilot#Previous()", { silent = true, expr = true })
			vim.api.nvim_set_keymap("i", "<C-H>", "copilot#Next()", { silent = true, expr = true })
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		-- pinned: newer versions removed CopilotChat.select/context API used below
		commit = "f84727fd79f726b7e848adf89108d66805638f06",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
			{ "nvim-telescope/telescope.nvim" },
		},
		build = "make tiktoken",
		opts = {},
		config = function()
			local select = require("CopilotChat.select")
			local buffer = select.buffer
			local context = require("CopilotChat.context")

			-- Add diagnostics selection function
			select.diagnostics = function(source)
				local bufnr = source.bufnr
				local winnr = source.winnr
				local select_buffer = buffer(source)
				if not select_buffer then
					return nil
				end

				local cursor = vim.api.nvim_win_get_cursor(winnr)
				local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = cursor[1] - 1 })

				if #line_diagnostics == 0 then
					return nil
				end

				local diagnostics = {}
				for _, diagnostic in ipairs(line_diagnostics) do
					table.insert(diagnostics, diagnostic.message)
				end

				local result = table.concat(diagnostics, ". ")
				result = result:gsub("^%s*(.-)%s*$", "%1"):gsub("\n", " ")

				local file_name = vim.api.nvim_buf_get_name(bufnr)

				local out = {
					content = file_name .. ":" .. cursor[1] .. ". " .. result,
					filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:."),
					filetype = vim.bo[bufnr].filetype,
					start_line = cursor[1],
					end_line = cursor[1],
					bufnr = bufnr,
				}

				return out
			end

			-- Add gitdiff selection function
			select.gitdiff = function(source, staged)
				local select_buffer = buffer(source)
				if not select_buffer then
					return nil
				end
				local file_path = vim.api.nvim_buf_get_name(source.bufnr)
				local file_dir = vim.fn.fnamemodify(file_path, ":h")
				-- check file dir is exist, or use current dir instead
				if vim.fn.isdirectory(file_dir) == 0 then
					file_dir = vim.fn.getcwd()
				end

				-- Security fix
				file_dir = file_dir:gsub(".git$", "")

				local cmd_diff = "git -C "
					.. file_dir
					.. " diff --no-color --no-ext-diff"
					.. (staged and " --staged" or "")
					.. " 2>/dev/null"
				local cmd_diff_stat = "git -C "
					.. file_dir
					.. " diff --stat --no-color --no-ext-diff"
					.. (staged and " --staged" or "")
					.. " 2>/dev/null"

				local handle = io.popen(cmd_diff)
				if not handle then
					return nil
				end

				local result = handle:read("*a")
				handle:close()

				-- If diff is too large, use diff --stat instead
				if #result > 30000 then
					handle = io.popen(cmd_diff_stat)
					if not handle then
						return nil
					end

					result = handle:read("*a")
					handle:close()
				end

				if not result or result == "" then
					return nil
				end

				return {
					content = result,
					filename = "git_diff_" .. (staged and "staged" or "unstaged"),
					filetype = "diff",
				}
			end

			-- Quick chat functions
			function CopilotChatQuickchat(ask)
				if ask == true then
					local ok, input = pcall(vim.fn.input, "Quick Chat: ")
					if ok and input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				else
					vim.cmd("CopilotChat")
				end
			end

			function CopilotChatNoContextchat()
				vim.cmd("CopilotChat")
			end

			function CopilotChatQuickchatVisual(ask)
				if ask == true then
					local ok, input = pcall(vim.fn.input, "Quick Chat: ")
					if ok and input ~= "" then
						vim.cmd("'<,'>CopilotChat " .. input)
					end
				else
					vim.cmd("'<,'>CopilotChat")
				end
			end

			-- File picker function that inserts the selected file path into the chat buffer
			function PickFileForCopilotChat()
				require("telescope.builtin").find_files({
					attach_mappings = function(_, map)
						map("i", "<CR>", function(prompt_bufnr)
							local selection = require("telescope.actions.state").get_selected_entry()
							require("telescope.actions").close(prompt_bufnr)

							if selection then
								local file_path = selection.value
								if not file_path then
									file_path = selection.path
								end

								-- Look for the Copilot Chat buffer
								local found = false
								for _, buf in ipairs(vim.api.nvim_list_bufs()) do
									local buf_name = vim.api.nvim_buf_get_name(buf)
									if buf_name:match("copilot%-") then
										-- We found the Copilot Chat buffer
										vim.api.nvim_set_current_buf(buf)

										-- Insert the file command at the current cursor position or at the end
										local cmd_text = "#file " .. file_path

										-- Check if the buffer is empty or has content
										local line_count = vim.api.nvim_buf_line_count(buf)
										if
											line_count > 0
											and vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1]
												~= ""
										then
											-- Append to a new line if the buffer has content
											vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, { cmd_text })
											vim.api.nvim_win_set_cursor(0, { line_count + 1, 0 })
										else
											-- Insert at the current position
											vim.api.nvim_put({ cmd_text }, "c", true, true)
										end

										found = true
										break
									end
								end

								if not found then
									-- If we didn't find a Copilot Chat buffer, open one
									vim.cmd("CopilotChat")
									-- Wait a bit for the buffer to be created
									vim.defer_fn(function()
										for _, buf in ipairs(vim.api.nvim_list_bufs()) do
											local buf_name = vim.api.nvim_buf_get_name(buf)
											if buf_name:match("copilot%-") then
												vim.api.nvim_set_current_buf(buf)
												vim.api.nvim_put({ "#file " .. file_path }, "c", true, true)
												break
											end
										end
									end, 100)
								end
							end

							return true
						end)
						return true
					end,
				})
			end

			-- Register our custom file picker as a command
			vim.api.nvim_create_user_command("CopilotChatPickFile", function()
				PickFileForCopilotChat()
			end, {})

			-- Configure main setup
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)

			local question_header = "  " .. user .. " "
			local answer_header = "  Copilot "

			require("CopilotChat").setup({
				agent = "copilot", -- Default agent to use
				temperature = 0.1, -- Result temperature
				show_help = true, -- Shows help message as virtual lines

				-- Default window options
				window = {
					layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
					width = 0.5, -- fractional width
					height = 0.5, -- fractional height
					relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
					border = "shadow", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
					title = "Copilot Chat", -- title of chat window
					filetype = "markdown",
				},

				question_header = question_header, -- Header for user questions
				answer_header = answer_header, -- Header for AI answers
				error_header = "> [!ERROR] Error", -- Header for errors
				separator = "---", -- Separator in chat

				-- Context setup with command definitions
				context = {
					-- Enable the following context by default
					enable = {
						-- Include language of current buffer
						language = true,
						-- Include content of current buffer
						buffer = true,
					},
				},

				-- Define the context commands that will be available in the Copilot Chat buffer
				context_selections = {
					["#buffer"] = {
						handler = context.buffer,
						desc = "Includes specified buffer in chat context. Supports input (default current).",
					},
					["#buffers"] = {
						handler = context.buffers,
						desc = "Includes all buffers in chat context. Supports input (default listed).",
					},
					["#file"] = {
						handler = context.file,
						desc = "Includes content of provided file in chat context. Supports input.",
					},
					["#files"] = {
						handler = context.files,
						desc = "Includes files from pattern in chat context.",
					},
					["#files:full"] = {
						handler = context.files,
						desc = "Includes all non-hidden files in the current workspace in chat context.",
						opts = { all_files = true },
					},
					["#git"] = {
						handler = context.git,
						desc = "Requires 'git'. Includes current git diff in chat context. Supports input.",
					},
					["#register"] = {
						handler = context.register,
						desc = "Includes contents of register in chat context. Supports input (default +, e.g., @a).",
					},
					["#url"] = {
						handler = context.url,
						desc = "Includes content of provided URL in chat context. Supports input.",
					},
				},

				-- Custom prompts
				prompts = {
					Explain = {
						prompt = "Explain how the following code works in detail.",
					},
					Review = {
						prompt = "Review the following code and provide suggestions for improvement.",
					},
					Refactor = {
						prompt = "Refactor the following code to improve its clarity and readability.",
					},
					Tests = {
						prompt = "Generate comprehensive tests for the following code.",
					},
					FixCode = {
						prompt = "Fix the following code to make it work correctly.",
					},
					Optimize = {
						prompt = "Optimize the following code for better performance.",
					},
					Documentation = {
						prompt = "Generate thorough documentation for the following code.",
					},
					Commit = {
						prompt = "Write a commit message for the following changes.",
						selection = select.gitdiff,
					},
					CommitStaged = {
						prompt = "Write a commit message for the following staged changes.",
						selection = function(source)
							return select.gitdiff(source, true)
						end,
					},
					FixDiagnostic = {
						prompt = "Fix the following diagnostic issue:",
						selection = select.diagnostics,
					},
				},
			})

			-- Set line numbers in Copilot Chat buffers
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.foldmethod = "expr"
					vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
					vim.opt_local.number = true
					vim.bo.filetype = "markdown"

					-- Add icons for code blocks
					require("nvim-web-devicons").setup()
				end,
			})

			-- Configure keymaps for CopilotChat
			local keymaps = {
				{ "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Open Copilot Chat" },
				{ "<leader>ze", ":CopilotChatExplain<CR>", mode = { "n", "v" }, desc = "Explain Code" },
				{ "<leader>zr", ":CopilotChatReview<CR>", mode = { "n", "v" }, desc = "Review Code" },
				{ "<leader>zM", ":CopilotChatModels<CR>", mode = { "n", "v" }, desc = "Switch chat models" },
				{ "<leader>zA", ":CopilotChatStop<CR>", mode = { "n", "v" }, desc = "Refactor Code" },
				{ "<leader>zf", ":CopilotChatFixCode<CR>", mode = { "n", "v" }, desc = "Fix Code" },
				{ "<leader>zo", ":CopilotChatOptimize<CR>", mode = { "n", "v" }, desc = "Optimize Code" },
				{ "<leader>zt", ":CopilotChatTests<CR>", mode = { "n", "v" }, desc = "Generate Tests" },
				{ "<leader>zd", ":CopilotChatDocumentation<CR>", mode = { "n", "v" }, desc = "Generate Docs" },
				{ "<leader>zg", ":lua CopilotChatQuickchat(false)<CR>", mode = "n", desc = "Quick Chat" },
				{ "<leader>zG", ":lua CopilotChatQuickchat(true)<CR>", mode = "n", desc = "Quick Chat with Input" },
				{ "<leader>zR", ":CopilotChatReset<CR>", mode = { "n", "v" }, desc = "Reset Chat" },
				{
					"<leader>zV",
					":lua CopilotChatQuickchatVisual(false)<CR>",
					mode = "v",
					desc = "Chat with Selection",
				},
				{
					"<leader>zv",
					":lua CopilotChatQuickchatVisual(true)<CR>",
					mode = "v",
					desc = "Chat with Selection & Prompt",
				},
				{ "<leader>zp", ":CopilotChatPrompts<CR>", mode = { "n", "v" }, desc = "Prompt Actions" },
				{ "<leader>zC", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
				{ "<leader>zS", ":CopilotChatCommitStaged<CR>", mode = "n", desc = "Generate Commit for Staged" },
				{ "<leader>zF", ":CopilotChatFixDiagnostic<CR>", mode = "n", desc = "Fix Diagnostic" },
				-- Add dedicated keybinding for file picking with a better mnemonic for "file"
				{ "<leader>zs", ":CopilotChatPickFile<CR>", mode = "n", desc = "Select File for Copilot Chat" },
				{ "<leader>zP", ":CopilotChatPickFile<CR>", mode = "n", desc = "Pick File for Copilot Chat" },

				-- Add keymap that will work when in the Copilot Chat buffer
				{ "<C-f>", ":CopilotChatPickFile<CR>", mode = "n", desc = "Pick File (in Chat)" },
			}

			for _, keymap in ipairs(keymaps) do
				if type(keymap.mode) == "table" then
					for _, mode in ipairs(keymap.mode) do
						vim.api.nvim_set_keymap(
							mode,
							keymap[1],
							keymap[2],
							{ noremap = true, silent = true, desc = keymap.desc }
						)
					end
				else
					vim.api.nvim_set_keymap(
						keymap.mode,
						keymap[1],
						keymap[2],
						{ noremap = true, silent = true, desc = keymap.desc }
					)
				end
			end

			-- Set up a buffer-local keymap for the Copilot Chat buffer specifically
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "copilot-*",
				callback = function()
					-- Add a keymap that only works in the Copilot Chat buffer
					vim.api.nvim_buf_set_keymap(
						0,
						"n",
						"<C-f>",
						":CopilotChatPickFile<CR>",
						{ noremap = true, silent = true, desc = "Pick a file" }
					)
				end,
			})
		end,
	},
}
