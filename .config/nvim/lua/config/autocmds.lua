-- autocommands personalizados

-- quitar trailing whitespace al guardar
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- desactivar auto-comentario en nueva linea
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- persistir colorscheme al cambiarlo
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function(args)
    local colorscheme_file = vim.fn.stdpath("config") .. "/.colorscheme"
    local f = io.open(colorscheme_file, "w")
    if f then
      f:write(args.match)
      f:close()
    end
  end,
})
