local M = {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufRead",
}

function M.config()
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldnestmax = 1
    vim.o.foldenable = true

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set("n", "K", function() require("ufo").peekFoldedLinesUnderCursor() end)
    vim.keymap.set("n", "zk", function()
        require("ufo").goPreviousStartFold()
        vim.cmd [[norm 0]] -- so its consistent with builtin zj keymap
    end)

    local ft_map = {
        vim = "indent",
        python = { "indent" },
        git = "",
    }
    require("ufo").setup {
        -- open_fold_hl_timeout = 400,
        provider_selector = function(bufnr, filetype, buftype)
            -- NOTE: lsp -> treesitter -> indent to provide folds
            -- NOTE: need to enable aditional capabilities in the lsp config to get lsp folding to work
            -- local function handleFallbackException(bufnr, err, providerName)
            --     if type(err) == "string" and err:match "UfoFallbackException" then
            --         return require("ufo").getFolds(bufnr, providerName)
            --     else
            --         return require("promise").reject(err)
            --     end
            -- end
            --
            -- return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
            --     or function(bufnr)
            --         return require("ufo")
            --             .getFolds(bufnr, "lsp")
            --             :catch(function(err) return handleFallbackException(bufnr, err, "treesitter") end)
            --             :catch(function(err) return handleFallbackException(bufnr, err, "indent") end)
            --     end
            return ft_map[filetype] or { "treesitter", "indent" }
        end,
        -- close_fold_kinds = {},
        -- NOTE: truncated folded line + number of lines folded + last line of fold
        enable_get_fold_virt_text = true,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
            -- local function get_first_non_whitespace(virt_line)
            --
            -- end
            -- if virtText[1][1] == "MAP" or virtText[2][1] == "MAP" then
            --     table.insert(virtText, { "mapfunc", "MoreMsg" })
            -- end
            local newVirtText = {}
            local suffix = (" 🡯 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            local remove_leading_whitespace = true
            for _, v in ipairs(ctx.get_fold_virt_text(endLnum)) do
                if not remove_leading_whitespace or v[2] ~= "UfoFoldedFg" then
                    remove_leading_whitespace = false
                    table.insert(newVirtText, v)
                end
            end
            return newVirtText
        end,
        preview = {
            -- win_config = {
            --     border = "rounded",
            --     winblend = 12,
            --     winhighlight = "Normal:Normal",
            --     maxheight = 20,
            -- },
            mappings = {
                scrollB = "<C-b>",
                scrollF = "<C-f>",
                scrollU = "<C-u>",
                scrollD = "<C-d>",
                -- scrollE = "<C-E>",
                -- scrollY = "<C-Y>",
                -- close = "q",
                switch = "K",
                -- trace = "<CR>",
            },
        },
    }
end

return M
