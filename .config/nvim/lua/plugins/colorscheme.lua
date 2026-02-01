return {
	-- guarda el colorscheme elegido en un archivo para persistirlo
	{
		"LazyVim/LazyVim",
		opts = function(_, opts)
			local colorscheme_file = vim.fn.stdpath("config") .. "/.colorscheme"
			local f = io.open(colorscheme_file, "r")
			if f then
				opts.colorscheme = f:read("*l")
				f:close()
			end
		end,
	},

	{ "folke/tokyonight.nvim", lazy = false },
	{ "ellisonleao/gruvbox.nvim", lazy = false },
	{ "rose-pine/neovim", name = "rose-pine", lazy = false },
	{ "projekt0n/github-nvim-theme", lazy = false },
	{ "rebelot/kanagawa.nvim", lazy = false },
	{ "datsfilipe/min-theme.nvim", lazy = false },
}
