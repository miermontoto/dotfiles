return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-j>]],
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
      },
    },
    keys = {
      { "<C-j>", "<cmd>ToggleTerm direction=horizontal<CR>", mode = { "n", "t" }, desc = "terminal horizontal" },
    },
  },
}
