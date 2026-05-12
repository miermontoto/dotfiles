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
  -- lspconfig: usar marksman del sistema (nix) en lugar del binario .net de mason,
  -- que falla en nixos por falta de libicu en /usr
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          mason = false,
        },
      },
    },
  },
}
