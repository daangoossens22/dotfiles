local M = {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
}

function M.config()
    require("notify").setup {
        -- render = "minimal",
        stages = "static",
    }
    local notify = require "notify"
    vim.notify = notify

    MAP("n", "<leader>nd", notify.dismiss, "removes all notifications")
end

return M
