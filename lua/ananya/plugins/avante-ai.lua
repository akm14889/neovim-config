return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{ "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = { file_types = { "markdown", "Avante" } },
			ft = { "markdown", "Avante" },
		},
	},
	build = "make",
	-- opts = {
	-- 	provider = "copilot",
	-- 	copilot = {
	-- 		model = "gpt-4o-2024-11-20",
	-- 		-- model = "gpt-o3-mini",
	-- 	},
	-- },
	opts = {
		provider = "claude",
		providers = {
			claude = {
				model = "claude-sonnet-5-5",
			},
		},
	},
}
