local M = {
    "echasnovski/mini.nvim",
    lazy = false,
    version = false,
}

M.config = function()
    require("mini.ai").setup()
    require("mini.splitjoin").setup()
    -- require("mini.animate").setup {
    --     cursor = { enable = false },
    --     scroll = {
    --         enable = true,
    --     },
    --     resize = { enable = false },
    --     open = { enable = false },
    --     close = { enable = false },
    -- }
    -- require("mini.operators").setup()
    -- require("mini.pairs").setup()
    -- require("mini.surround").setup()
end

return M
