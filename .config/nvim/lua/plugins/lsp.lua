return {
  -- mason: herramientas adicionales
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "lua-language-server",
        "prettier",
        "stylua",
      },
    },
  },
}
