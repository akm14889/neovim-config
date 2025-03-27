return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                                                         ",
			" █████╗ ███╗   ██╗ █████╗ ███╗   ██╗██╗   ██╗ █████╗      ██╗   ██╗██╗███╗   ███╗",
			"██╔══██╗████╗  ██║██╔══██╗████╗  ██║╚██╗ ██╔╝██╔══██╗     ██║   ██║██║████╗ ████║",
			"███████║██╔██╗ ██║███████║██╔██╗ ██║ ╚████╔╝ ███████║     ██║   ██║██║██╔████╔██║",
			"██╔══██║██║╚██╗██║██╔══██║██║╚██╗██║  ╚██╔╝  ██╔══██║     ╚██╗ ██╔╝██║██║╚██╔╝██║",
			"██║  ██║██║ ╚████║██║  ██║██║ ╚████║   ██║   ██║  ██║      ╚████╔╝ ██║██║ ╚═╝ ██║",
			"╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝       ╚═══╝  ╚═╝╚═╝     ╚═╝",
			"                                                         ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("SPC nh", "  > Clear search highlights", ":nohl<CR>"),
			dashboard.button("SPC sv", "  > Split window vertically", "<C-w>v"),
			dashboard.button("SPC sh", "  > Split window horizontally", "<C-w>s"),
			dashboard.button("SPC se", "  > Make splits equal size", "<C-w>="),
			dashboard.button("SPC to", "  > Open new tab", "<cmd>tabnew<CR>"),
			dashboard.button("SPC tn", "  > Go to next tab", "<cmd>tabn<CR>"),
			dashboard.button("SPC tp", "  > Go to previous tab", "<cmd>tabp<CR>"),
			dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
