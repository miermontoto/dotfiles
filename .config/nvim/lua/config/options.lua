-- opciones que sobreescriben lazyvim defaults
local opt = vim.opt

-- apariencia
opt.background = "light"
opt.colorcolumn = "80"
opt.cursorline = true -- resalta la linea actual
opt.relativenumber = false -- numeros absolutos (mas familiar para ide users)

-- indentacion (default 2 espacios, php usa 4 en ftplugin)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- comportamiento
opt.scrolloff = 8 -- mantiene 8 lineas visibles arriba/abajo del cursor
opt.sidescrolloff = 8
opt.confirm = true -- pregunta antes de cerrar sin guardar
opt.mouse = "a" -- mouse habilitado en todos los modos
opt.clipboard = "unnamedplus" -- usa el clipboard del sistema por defecto

-- wrap
opt.wrap = false

-- caracteres invisibles
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- fold (usando treesitter nativo)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

-- busqueda
opt.ignorecase = true -- busqueda case-insensitive
opt.smartcase = true -- a menos que uses mayusculas

-- rendimiento
opt.updatetime = 50 -- minimo practico para hover y diagnosticos

-- undo persistente (como historial de vscode)
opt.undofile = true
opt.undolevels = 10000

-- wrap cursor al inicio/fin de linea
opt.whichwrap:append("<,>,[,],h,l")
