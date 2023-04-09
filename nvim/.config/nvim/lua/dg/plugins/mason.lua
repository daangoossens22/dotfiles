local M = {
    "williamboman/mason.nvim",
    cmd = {
        "Mason",
        "MasonInstall",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
        "LspInstall",
        "LspUninstall",
    },
    dependencies = { "williamboman/mason-lspconfig.nvim" },
}

function M.init() MAP("n", "<leader>ml", "<cmd>Mason<cr>", "[MASON] list packages") end

function M.config()
    require("mason").setup {
        ui = {
            border = "rounded",
        },
    }
    local mason_packages = {
        "stylua",
        "prettier",
        "yapf",
        "shellharden",
        "shellcheck",
        "codelldb",
        "debugpy",
    }
    for _, cur_package in ipairs(mason_packages) do
        local p = require("mason-registry").get_package(cur_package)
        if not p:is_installed() then p:install() end
    end

    require("mason-lspconfig").setup {
        ensure_installed = {},
        automatic_installation = { exclude = { "rust_analyzer" } },
        PATH = "append",
    }
end

return M
