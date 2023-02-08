local opt = vim.opt

-- NOTE: global options
opt.termguicolors = true
opt.fsync = true
opt.wildmode = "longest:full"
opt.splitright = true
opt.splitbelow = true
opt.errorbells = false
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.showmatch = true
opt.showcmd = true
-- opt.cmdheight = 0
opt.ruler = true
opt.smarttab = true
opt.path:append { "**" }
opt.undofile = true
opt.scrolloff = 4 -- scroll before reaching beginning/end screen
opt.autowrite = true
opt.autowriteall = true
opt.title = true
opt.titlestring = "nvim - %t"
opt.mouse = "nv" -- enable mouse in normal, visual
-- opt.clipboard = "unnamedplus" -- automatically copy to clipboard
opt.foldlevelstart = 20
opt.splitkeep = "screen"
-- opt.diffopt:append { "linematch:60", "algorithm:patience" }
opt.diffopt:append "vertical"
-- opt.virtualedit = "all"
opt.fillchars:append "diff:╱"

-- backup for writefailures
-- successfull save => backup removed
opt.backup = false
opt.writebackup = true
opt.backupext = ".bak"

opt.wildignore:append { "*.o", "*.pyc", "*pycache*", "*.png", "*.jpg", "build/*" }

-- opt.hidden = false

-- NOTE: local to window options
opt.cursorline = true
opt.cursorlineopt = "number"
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.textwidth = 110
opt.colorcolumn = { "+1" }
opt.foldenable = false

-- NOTE: local to buffer options
opt.autoindent = true
--opt.copyindent = true
opt.expandtab = true
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.modeline = true
-- opt.scrollback = 1000 -- number of lines beyond the screen that are kept in memory

-- -- NOTE: disable builtin plugins (now done in lazy.nvim)
-- vim.g.loaded_gzip = 1
-- vim.g.loaded_zip = 1
-- vim.g.loaded_zipPlugin = 1
-- vim.g.loaded_tar = 1
-- vim.g.loaded_tarPlugin = 1
-- vim.g.loaded_vimball = 1
-- vim.g.loaded_vimballPlugin = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrwFileHandlers = 1
-- vim.g.loaded_netrwSettings = 1
-- vim.g.loaded_matchit = 1
-- vim.g.loaded_2html_plugin = 1
-- vim.g.loaded_tutor_mode_plugin = 1

vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_pythonx_provider = 0
vim.g.loaded_python3_provider = 0

local dg_options = vim.api.nvim_create_augroup("dg_option", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if ev.match ~= "gitcommit" then vim.opt_local.formatoptions:remove { "o", "t" } end
    end,
    group = dg_options,
})
-- persistant folds and cursor position when opening and closing nvim
-- gotten from: https://vim.fandom.com/wiki/Make_views_automatic
vim.opt.viewoptions = {
    "folds",
    "cursor",
    -- "curdir",
}
vim.api.nvim_create_autocmd({ "BufWritePost", "BufLeave", "WinLeave" }, {
    pattern = "?*",
    command = "mkview",
    group = dg_options,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "?*",
    command = "silent! loadview",
    group = dg_options,
})
