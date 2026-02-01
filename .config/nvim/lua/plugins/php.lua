return {
  -- override intelephense settings from lazyvim php extra
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = { enabled = false },
        intelephense = {
          settings = {
            intelephense = {
              files = { maxSize = 5000000 },
              environment = { phpVersion = "8.4" },
              format = { enable = false },
            },
          },
        },
      },
    },
  },
}
