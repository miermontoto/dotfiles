-- keymaps personalizados que sobreescriben lazyvim
local map = vim.keymap.set

-- workspaces/proyectos recientes
map("n", "<C-r>", "<cmd>lua Snacks.picker.projects()<CR>")

-- command palette
map("n", "<C-S-p>", "<cmd>lua Snacks.picker.commands()<CR>")

-- file explorer
map("n", "<C-e>", "<cmd>lua Snacks.explorer()<CR>")

-- find files y git
map("n", "<C-p>", "<cmd>lua Snacks.picker.files()<CR>")
map("n", "<C-g>", "<cmd>lua Snacks.picker.git_status()<CR>")

-- comentarios
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- guardar rapido
map("n", "<leader>w", "<cmd>w<CR>")

-- ctrl+s guardar
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>")

-- ctrl+z undo en insert mode
map("i", "<C-z>", "<Esc>ua")

-- ctrl+y redo
map({ "n", "i" }, "<C-y>", "<cmd>redo<CR>")

-- ctrl+a seleccionar todo
map("n", "<C-a>", "ggVG")

-- ctrl+c/v copiar/pegar con clipboard
map("v", "<C-c>", '"+y')
map("n", "<C-v>", '"+p')
map("v", "<C-v>", '"_d"+P')
map("i", "<C-v>", '<Esc>"+pa')

-- rastrear si venimos de insert mode
vim.g.from_insert_mode = false
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "i:*",
  callback = function() vim.g.from_insert_mode = true end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "n:*",
  callback = function() vim.g.from_insert_mode = false end,
})

-- en visual mode, escribir reemplaza seleccion solo si veniamos de insert
for i = 32, 126 do
  local char = string.char(i)
  local escaped = char
  if char == '"' or char == "\\" or char == "|" then
    escaped = "\\" .. char
  end
  map("v", char, function()
    if vim.g.from_insert_mode then
      return '"_c' .. char
    else
      return char
    end
  end, { expr = true })
end

-- ctrl+x cortar
map("n", "<C-x>", '"+dd')
map("v", "<C-x>", '"+d')

-- ctrl+d ir a linea
map("n", "<C-d>", function()
  vim.ui.input({ prompt = "Go to line: " }, function(input)
    if input and input ~= "" then
      local line = tonumber(input)
      if line then
        vim.cmd(tostring(line))
      end
    end
  end)
end)

-- ctrl+/ comentar
map("n", "<C-/>", "gcc", { remap = true })
map("v", "<C-/>", "gc", { remap = true })

-- alt+up/down mover lineas
map("n", "<A-Up>", "<cmd>m .-2<CR>==")
map("n", "<A-Down>", "<cmd>m .+1<CR>==")
map("v", "<A-Up>", ":m '<-2<CR>gv=gv")
map("v", "<A-Down>", ":m '>+1<CR>gv=gv")

-- ctrl+f buscar
map("n", "<C-f>", "/")

-- ctrl+shift+h buscar y reemplazar
map("n", "<C-S-h>", ":%s/")

-- ctrl+shift+f buscar en proyecto
map("n", "<C-S-f>", "<cmd>lua Snacks.picker.grep()<CR>")

-- ctrl+b toggle sidebar
map("n", "<C-b>", "<cmd>lua Snacks.explorer()<CR>")

-- F2 renombrar simbolo
map("n", "<F2>", vim.lsp.buf.rename)

-- F12 ir a definicion
map("n", "<F12>", vim.lsp.buf.definition)

-- ctrl+click ir a definicion via lsp
map("n", "<C-LeftMouse>", function()
  local pos = vim.fn.getmousepos()
  if pos.winid > 0 then
    vim.api.nvim_set_current_win(pos.winid)
    vim.api.nvim_win_set_cursor(pos.winid, { pos.line, pos.column - 1 })
  end
  vim.lsp.buf.definition()
end)

-- shift+F12 ver referencias
map("n", "<S-F12>", vim.lsp.buf.references)

-- escape limpiar busqueda
map("n", "<Esc>", "<cmd>noh<CR><Esc>")

-- ctrl+tab ciclar buffers
map("n", "<C-Tab>", "<cmd>bnext<CR>")
map("n", "<C-S-Tab>", "<cmd>bprevious<CR>")

-- alt+w cerrar buffer
vim.g.closed_buffers = {}
map("n", "<A-w>", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname ~= "" then
    table.insert(vim.g.closed_buffers, bufname)
  end
  vim.cmd("bdelete")
end)

-- ctrl+shift+t reabrir buffer cerrado
map("n", "<C-S-t>", function()
  if #vim.g.closed_buffers > 0 then
    local last = table.remove(vim.g.closed_buffers)
    vim.cmd("edit " .. vim.fn.fnameescape(last))
  else
    vim.notify("No hay buffers cerrados", vim.log.levels.INFO)
  end
end)

-- mouse back/forward navegacion (jumplist)
map({ "n", "i", "v" }, "<X1Mouse>", "<C-o>")
map({ "n", "i", "v" }, "<X2Mouse>", "<C-i>")
map({ "n", "i", "v" }, "<MouseBack>", "<C-o>")
map({ "n", "i", "v" }, "<MouseForward>", "<C-i>")

-- space+h dashboard
map("n", "<leader>h", "<cmd>lua Snacks.dashboard()<CR>")

-- busqueda (space+f)
map("n", "<leader>ff", "<cmd>lua Snacks.picker.files()<CR>")
map("n", "<leader>fg", "<cmd>lua Snacks.picker.grep()<CR>")
map("n", "<leader>fb", "<cmd>lua Snacks.picker.buffers()<CR>")
map("n", "<leader>fr", "<cmd>lua Snacks.picker.recent()<CR>")
map("n", "<leader>fw", "<cmd>lua Snacks.picker.grep_word()<CR>")

-- simbolos en archivo
map("n", "<leader>fs", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local has_lsp = false
  for _, client in ipairs(clients) do
    if client.name ~= "copilot" and client.name ~= "GitHub Copilot" then
      has_lsp = true
      break
    end
  end
  if has_lsp then
    Snacks.picker.lsp_symbols()
  else
    Snacks.picker.treesitter()
  end
end)

-- simbolos en proyecto
map("n", "<leader>fS", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local has_lsp = false
  for _, client in ipairs(clients) do
    if client.name ~= "copilot" and client.name ~= "GitHub Copilot" then
      has_lsp = true
      break
    end
  end
  if has_lsp then
    Snacks.picker.lsp_workspace_symbols()
  else
    vim.notify("No LSP attached (copilot doesn't provide symbols)", vim.log.levels.WARN)
  end
end)
