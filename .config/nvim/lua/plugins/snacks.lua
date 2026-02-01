return {
	{
		"folke/snacks.nvim",
		opts = {
			scroll = { enabled = false },
			animate = { enabled = false },
			gitbrowse = { enabled = true },
			explorer = {
				replace_netrw = false,
			},
			picker = {
				sources = {
					files = {
						hidden = true,
						ignored = false,
					},
					explorer = {
						hidden = true,
						ignored = false,
						layout = {
							preset = "sidebar",
							preview = false,
							layout = {
								position = "right",
								box = "vertical",
								{ win = "list", border = "none" },
							},
						},
						win = {
							list = {
								keys = {
									["<a-h>"] = "toggle_hidden",
									["<a-i>"] = "toggle_ignored",
								},
							},
						},
					},
				},
			},
		},
	},
}
