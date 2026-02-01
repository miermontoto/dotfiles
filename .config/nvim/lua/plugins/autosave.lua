return {
  -- autosave automatico
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
      },
      debounce_delay = 1000, -- espera 1 segundo antes de guardar
      condition = function(buf)
        -- no guardar si el formato esta en progreso o si es un buffer especial
        local filetype = vim.bo[buf].filetype
        local buftype = vim.bo[buf].buftype
        local modifiable = vim.bo[buf].modifiable
        local ignore_filetypes = { "neo-tree", "lazy", "mason", "TelescopePrompt" }
        return modifiable
          and buftype == ""
          and not vim.tbl_contains(ignore_filetypes, filetype)
      end,
    },
  },
}
