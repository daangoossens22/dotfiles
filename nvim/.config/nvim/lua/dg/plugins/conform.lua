local M = {
    "stevearc/conform.nvim",
}

function M.config()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    local function toggle_autoformat(lang)
        lang = lang or vim.bo.filetype
        AUTOFORMAT_LANGUAGES[lang] = not AUTOFORMAT_LANGUAGES[lang]
    end
    local function format(bufnr)
        bufnr = bufnr or 0
        require("conform").format {
            bufnr = bufnr,
            timeout_ms = 500,
            lsp_format = "fallback",
            quiet = true,
        }
    end
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
            if AUTOFORMAT_LANGUAGES[vim.bo.filetype] then format(args.buf) end
        end,
        group = AUGROUP "lsp_autoformat",
    })
    vim.keymap.set("n", "gqb", format, { desc = "formats the current buffer" })
    vim.keymap.set("n", "<leader>taf", toggle_autoformat, { desc = "toggle format current buffer on write" })
    require("conform").setup {
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shellharden" },
        },
    }
end

return M
