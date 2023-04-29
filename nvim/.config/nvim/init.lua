local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=main",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
require "dg.globals"
require("lazy").setup("dg.plugins", {
    defaults = { lazy = true },
    install = { colorscheme = { "kanagawa", "habamax" } },
    dev = { path = "~/Documents/nvim_plugins" },
    ui = { border = "rounded" },
    diff = { cmd = "diffview.nvim" },
    change_detection = { notify = false },
    performance = {
        cache = { enabled = true },
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "zipPlugin",
                "tutor",
                "matchit",
            },
        },
    },
})
MAP("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "update plugins" })
MAP("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "list plugins" })

require "dg.options"
require "dg.keymaps"
