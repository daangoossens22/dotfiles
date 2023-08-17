local opt = vim.opt
local o = vim.o
local g = vim.g

o.foldlevel = 99
o.foldlevelstart = 99
o.foldnestmax = 1
o.foldenable = true

-- NOTE: global options
o.termguicolors = true
o.fsync = true
o.wildmode = "longest:full"
o.splitright = true
o.splitbelow = true
o.errorbells = false
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.showmatch = true
o.showcmd = true
-- o.cmdheight = 0
o.ruler = true
o.smarttab = true
opt.path:append { "**" }
o.undofile = true
opt.shada = { "!", "'1000", "<50", "s10", "h" }
o.scrolloff = 6 -- scroll before reaching beginning/end screen
o.autowrite = true
o.autowriteall = true
o.title = true
o.titlestring = "nvim - %t"
o.mouse = "nv" -- enable mouse in normal, visual
o.mousescroll = "ver:1,hor:1"
-- o.clipboard = "unnamedplus" -- automatically copy to clipboard
-- o.foldlevelstart = 20
o.splitkeep = "screen"
-- opt.diffopt:append { "linematch:60", "algorithm:patience" }
opt.diffopt:append "vertical"
-- vim.opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }
-- o.virtualedit = "all"
opt.fillchars = { diff = "╱", fold = " ", foldopen = "⮟", foldsep = " ", foldclose = "⮞" }
-- o.inccommand = "split"
o.modelines = 1
o.updatetime = 1000
o.pumblend = 17
o.wildoptions = "pum"

-- backup for writefailures
-- successfull save => backup removed
o.backup = false
o.writebackup = true
o.backupext = ".bak"

opt.wildignore:append { "*.o", "*.pyc", "*pycache*", "*.png", "*.jpg", "build/*" }

-- NOTE: local to window options
o.cursorline = true
o.cursorlineopt = "number"
o.number = true
o.relativenumber = true
o.wrap = false
o.textwidth = 110
o.colorcolumn = "+1"
o.conceallevel = 2
o.foldcolumn = "1"
o.smoothscroll = true
o.signcolumn = "yes"
o.linebreak = true
o.breakindent = true

-- NOTE: local to buffer options
o.autoindent = true
--o.copyindent = true
o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.modeline = true
-- o.scrollback = 1000 -- number of lines beyond the screen that are kept in memory

-- -- NOTE: disable builtin plugins (now done in lazy.nvim)
-- g.loaded_gzip = 1
-- g.loaded_zip = 1
-- g.loaded_zipPlugin = 1
-- g.loaded_tar = 1
-- g.loaded_tarPlugin = 1
-- g.loaded_vimball = 1
-- g.loaded_vimballPlugin = 1
-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
-- g.loaded_netrwFileHandlers = 1
-- g.loaded_netrwSettings = 1
-- g.loaded_matchit = 1
-- g.loaded_2html_plugin = 1
-- g.loaded_tutor_mode_plugin = 1

g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_pythonx_provider = 0
g.loaded_python3_provider = 0
