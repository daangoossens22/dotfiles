-- fold options
vim.opt.fillchars = { diff = "╱", fold = " ", foldopen = "🞃", foldsep = " ", foldclose = "🞂" }
vim.o.foldcolumn = "auto:1"
vim.o.foldlevelstart = 99
vim.o.foldtext = ""
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- global options
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- vim.o.cmdheight = 0
-- vim.opt.path:append { "**" }
-- vim.o.undofile = true
vim.o.scrolloff = 4
vim.o.title = true
vim.o.titlestring = "nvim %f %m"
vim.o.mouse = "nv"
vim.o.mousescroll = "ver:1,hor:1"
-- vim.o.splitkeep = "screen"
-- opt.diffopt:append { "linematch:60", "algorithm:patience" }
-- vim.opt.diffopt:append "vertical"
vim.o.virtualedit = "block"

-- local to window options
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.textwidth = 120
vim.o.colorcolumn = "+1"
-- vim.o.conceallevel = 2
vim.o.smoothscroll = true
vim.o.signcolumn = "auto:2"
vim.o.breakindent = true
vim.o.numberwidth = 1

-- local to buffer options (can be overwritten by ftplugins)
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.softtabstop = -1 -- use the value of shiftwidth
vim.o.shiftwidth = 4
vim.o.formatoptions = table.concat {
    -- "t", -- auto-wrap
    "c", -- auto-wrap comments
    "r", -- add comment leader after hitting <Enter> in a comment
    "o", -- add comment leader after hitting 'o' or 'O' (undo with i<C-u>)
    -- "/", -- ???
    "q", -- allow formatting of comments using 'gq'
    -- "w", -- line that ends in a non-wite space character denotes the end of the paragraph
    -- "a", -- auto-format paragraphs (+c flag -> only do this in comments)
    "n", -- indents text when wrapping when using a numbered list (autoindent needs to be set)
    -- "2", -- copy indent of second line in paragraph (autoindent needs to be set)
    -- "v", -- vi-compatible auto-wrap in insert mode
    -- "b", -- ???
    "l", -- long line is not wrapped in insert mode when the line was already longer than textwidth
    -- "m", -- breaks multibyte characters above 255 (usefull for asian characters)
    -- "M", -- when joining lines don't insert space before or after multibyte character
    -- "B", -- when joining lines don't insert space between multibyte character
    -- "1", -- don't break line before one-letter words (do it before that)
    -- "]", -- no line can be longer than textwidth (only works for utf-8)
    "j", -- remove comment leader when joining lines
    -- "p", -- don't break lines at period followed by a space but one before that
}

vim.filetype.add {
    extension = {
        vh = "verilog",
    },
}
