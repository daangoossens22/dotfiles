local M = {
    "rebelot/kanagawa.nvim",
    priority = 1000,
}

function M.config()
    require("kanagawa").setup {
        dimInactive = true,
    }
    vim.cmd.colorscheme "kanagawa"
end

return M
