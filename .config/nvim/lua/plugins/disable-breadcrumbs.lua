return {
  -- desactivar breadcrumbs
  {
    "SmiteshP/nvim-navic",
    enabled = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        disabled_filetypes = { winbar = { "*" } },
      },
      winbar = {},
      inactive_winbar = {},
    },
  },
}
