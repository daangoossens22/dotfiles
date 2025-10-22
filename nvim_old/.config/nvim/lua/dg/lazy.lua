local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
    defaults = {
        lazy = true,
        -- version = "*"
    },
    spec = {
        { import = "dg.plugins" },
    },
    install = { colorscheme = { "kanagawa", "habamax" } },
    dev = { path = "~/Documents/nvim_plugins" },
    ui = {
        border = "rounded",
    },
    diff = { cmd = "diffview.nvim" },
    change_detection = { enabled = false, notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
}
MAP("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "update plugins" })
MAP("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "list plugins" })
